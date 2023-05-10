class Bundler::Source::Rubygems
  def install(spec, options = {})
    force = options[:force]
    ensure_builtin_gems_cached = options[:ensure_builtin_gems_cached]

    if ensure_builtin_gems_cached && spec.default_gem? && !cached_path(spec)
      cached_built_in_gem(spec) unless spec.remote
      force = true
    end

    if installed?(spec) && !force
      print_using_message("Using #{version_message(spec, options[:previous_spec])}")
      return nil
    end

    if spec.remote
      uris = [spec.remote, *remotes_for_spec(spec)].map(&:anonymized_uri).uniq
      Installer.ambiguous_gems << [spec.name, *uris] if uris.length > 1
    end

    path = fetch_gem_if_possible(spec, options[:previous_spec])
    raise GemNotFound, "Could not find #{spec.file_name} for installation" unless path

    return if Bundler.settings[:no_install]

    install_path = rubygems_dir
    bin_path     = Bundler.system_bindir

    require 'bundler/rubygems_gem_installer'

    installer = Bundler::RubyGemsGemInstaller.at(
      path,
      :security_policy => Bundler.rubygems.security_policies[Bundler.settings['trust-policy']],
      :install_dir => install_path.to_s,
      :bin_dir => bin_path.to_s,
      :ignore_dependencies => true,
      :wrappers => true,
      :env_shebang => true,
      :build_args => options[:build_args],
      :bundler_expected_checksum => spec.respond_to?(:checksum) && spec.checksum,
      :bundler_extension_cache_path => extension_cache_path(spec)
    )

    if spec.remote
      s = begin
        installer.spec
      rescue Gem::Package::FormatError
        Bundler.rm_rf(path)
        raise
      rescue Gem::Security::Exception => e
        raise SecurityError,
         "The gem #{File.basename(path, '.gem')} can't be installed because " \
         "the security policy didn't allow it, with the message: #{e.message}"
      end

      spec.__swap__(s)
    end

    message = "Installing #{version_message(spec, options[:previous_spec])}"
    message += ' with native extensions' if spec.extensions.any?
    Bundler.ui.confirm(message)

    installed_spec = installer.install

    spec.full_gem_path = installed_spec.full_gem_path
    spec.loaded_from = installed_spec.loaded_from

    spec.post_install_message
  end

  private

  def download_gem(spec, download_cache_path, _previous_spec = nil)
    uri = spec.remote.uri
    Bundler.ui.confirm("Fetching #{version_message(spec, nil)}")
    Bundler.rubygems.download_gem(spec, uri, download_cache_path)
  end
end
