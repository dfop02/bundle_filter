# require 'progressbar'
require 'bundler'
require 'bundle_filter/cli'
require 'bundle_filter/install'
require 'bundle_filter/plugin'
require 'bundle_filter/rubygems'

module BundleFilter
  Bundler::Plugin.add_hook('before-install-all') do |dependencies|
    # Hooks just to load plugin and replace files before run installs
    ENV['BUNDLE_SUPPRESS_INSTALL_USING_MESSAGES'] = 'true'
  end
end
