class Bundler::Source::Git
  def install(spec, options = {})
    force = options[:force]

    print_using_message "Using #{version_message(spec, options[:previous_spec])} from #{self}" unless BundleFilter::Configuration.pretty

    if (requires_checkout? && !@copied) || force
      Bundler.ui.debug "  * Checking out revision: #{ref}"
      git_proxy.copy_to(install_path, submodules)
      serialize_gemspecs_in(install_path)
      @copied = true
    end

    generate_bin_options = { :disable_extensions => !Bundler.rubygems.spec_missing_extensions?(spec), :build_args => options[:build_args] }
    generate_bin(spec, generate_bin_options)

    requires_checkout? ? spec.post_install_message : nil
  end
end
