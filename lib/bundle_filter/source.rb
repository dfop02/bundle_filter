class Bundler::Source
  def version_message(spec, locked_spec = nil)
    message = spec.name.to_s

    if locked_spec
      locked_spec_version = locked_spec.version
      if locked_spec_version && spec.version != locked_spec_version
        message += Bundler.ui.add_color(' [', :white)
        message += Bundler.ui.add_color(locked_spec_version.to_s, version_color(locked_spec_version, spec.version))
        message += Bundler.ui.add_color(' => ', :white)
        message += Bundler.ui.add_color(spec.version.to_s, version_color(spec.version, locked_spec_version))
        message += Bundler.ui.add_color(']', :white)
      end
    end
    message += " #{spec.version}"    unless message.include?('=>')
    message += " (#{spec.platform})" if spec.platform != Gem::Platform::RUBY && !spec.platform.nil?

    message
  end

  private

  def version_color(spec_version, locked_spec_version)
    if Gem::Version.correct?(spec_version) && Gem::Version.correct?(locked_spec_version)
      # display yellow if there appears to be a regression
      earlier_version?(spec_version, locked_spec_version) ? :yellow : :green
    else
      # default to green if the versions cannot be directly compared
      :green
    end
  end

  def earlier_version?(spec_version, locked_spec_version)
    Gem::Version.new(spec_version) < Gem::Version.new(locked_spec_version)
  end

  def print_using_message(message)
    # suppress_install_using_messages
    # ignore 'suppress_install_using_messages' flag because was
    # introduced on bundler > 3
    message.include?('=>') ? Bundler.ui.info(message) : Bundler.ui.debug(message)
  end
end
