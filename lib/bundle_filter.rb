require 'bundler'
require 'bundle_filter/configuration'
require 'bundle_filter/cli'
require 'bundle_filter/source'
require 'bundle_filter/rubygems'
require 'bundle_filter/metadata'
require 'bundle_filter/git'
require 'bundle_filter/path'

module BundleFilter
  Bundler::Plugin.add_hook('before-install-all') do |dependencies|
    # Hooks just to load plugin and replace files before run installs
  end
end
