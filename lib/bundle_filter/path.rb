class Bundler::Source::Path
  def install(spec, options = {})
    using_message = "Using #{version_message(spec, options[:previous_spec])} from #{self}"
    using_message += " and installing its executables" unless spec.executables.empty?
    print_using_message using_message unless BundleFilter::Configuration.pretty
    generate_bin(spec, :disable_extensions => true)
    nil # no post-install message
  end
end
