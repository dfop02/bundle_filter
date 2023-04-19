class Bundler::Source::Metadata
  def install(spec, _opts = {})
    print_using_message "Using #{version_message(spec)}" unless BundleFilter::Configuration.pretty
    nil
  end
end
