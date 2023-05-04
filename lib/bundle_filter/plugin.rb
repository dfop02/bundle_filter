module Bundler::Plugin
  def gemfile_install(gemfile = nil, &inline)
    Bundler.settings.temporary(:frozen => false, :deployment => false) do
      builder = DSL.new
      if block_given?
        builder.instance_eval(&inline)
      else
        builder.eval_gemfile(gemfile)
      end
      builder.check_primary_source_safety
      definition = builder.to_definition(nil, true)

      return if definition.dependencies.empty?

      plugins = definition.dependencies.map(&:name).reject { |p| index.installed? p }

      return if plugins.empty?

      installed_specs = Installer.new.install_definition(definition)

      save_plugins plugins, installed_specs, builder.inferred_plugins
    end
  rescue RuntimeError => e
    unless e.is_a?(GemfileError)
      Bundler.ui.error "Failed to install plugin: #{e.message}\n  #{e.backtrace[0]}"
    end
    raise
  end
end
