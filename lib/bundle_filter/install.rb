class Bundler::CLI::Install
  def run
    Bundler.ui.level = "warn" if options[:quiet]

    warn_if_root

    Bundler.self_manager.install_locked_bundler_and_restart_with_it_if_needed

    Bundler::SharedHelpers.set_env "RB_USER_INSTALL", "1" if Bundler::FREEBSD

    # Disable color in deployment mode
    Bundler.ui.shell = Thor::Shell::Basic.new if options[:deployment]

    check_for_options_conflicts

    check_trust_policy

    if options[:deployment] || options[:frozen] || Bundler.frozen_bundle?
      unless Bundler.default_lockfile.exist?
        flag   = "--deployment flag" if options[:deployment]
        flag ||= "--frozen flag"     if options[:frozen]
        flag ||= "deployment setting"
        raise ProductionError, "The #{flag} requires a #{Bundler.default_lockfile.relative_path_from(SharedHelpers.pwd)}. Please make " \
                               "sure you have checked your #{Bundler.default_lockfile.relative_path_from(SharedHelpers.pwd)} into version control " \
                               "before deploying."
      end

      options[:local] = true if Bundler.app_cache.exist?

      Bundler.settings.set_command_option :deployment, true if options[:deployment]
      Bundler.settings.set_command_option :frozen, true if options[:frozen]
    end

    # When install is called with --no-deployment, disable deployment mode
    if options[:deployment] == false
      Bundler.settings.set_command_option :frozen, nil
      options[:system] = true
    end

    normalize_settings

    Bundler::Fetcher.disable_endpoint = options["full-index"]

    if options["binstubs"]
      Bundler::SharedHelpers.major_deprecation 2,
        "The --binstubs option will be removed in favor of `bundle binstubs --all`"
    end

    Plugin.gemfile_install(Bundler.default_gemfile) if Bundler.feature_flag.plugins?

    definition = Bundler.definition
    definition.validate_runtime!

    installer = Installer.install(Bundler.root, definition, options)

    Bundler.settings.temporary(cache_all_platforms: options[:local] ? false : Bundler.settings[:cache_all_platforms]) do
      Bundler.load.cache(nil, options[:local]) if Bundler.app_cache.exist? && !options["no-cache"] && !Bundler.frozen_bundle?
    end

    complete_msg = "Bundle complete! #{dependencies_count_for(definition)}, #{gems_installed_for(definition)}."

    puts BundleFilter::Configuration.style
    if BundleFilter::Configuration.default_style?
      Bundler.ui.confirm complete_msg
    elsif BundleFilter::Configuration.boxes_style?
      box_style = ("-" * complete_msg.length).insert(0, '|').insert(-1, '|')
      Bundler.ui.confirm box_style
      Bundler.ui.confirm complete_msg.insert(0, '|').insert(-1, '|')
      Bundler.ui.confirm box_style
    end

    Bundler::CLI::Common.output_without_groups_message(:install)

    # disable final message
    # if Bundler.use_system_gems?
    #   Bundler.ui.confirm "Use `bundle info [gemname]` to see where a bundled gem is installed."
    # else
    #   relative_path = Bundler.configured_bundle_path.base_path_relative_to_pwd
    #   Bundler.ui.confirm "Bundled gems are installed into `#{relative_path}`"
    # end

    Bundler::CLI::Common.output_post_install_messages installer.post_install_messages

    warn_ambiguous_gems

    if CLI::Common.clean_after_install?
      require_relative "clean"
      Bundler::CLI::Clean.new(options).run
    end

    Bundler::CLI::Common.output_fund_metadata_summary
  rescue Gem::InvalidSpecificationException
    Bundler.ui.warn "You have one or more invalid gemspecs that need to be fixed."
    raise
  end
end
