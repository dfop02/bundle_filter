# require 'progressbar'
require 'bundler'
require 'bundle_filter/source'
require 'bundle_filter/source_rubygems'

module BundleFilter
  Bundler::Plugin.add_hook('before-install-all') do |dependencies|
    # Hooks just to load plugin and replace files before run installs
  end
end
