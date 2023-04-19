require_relative 'lib/bundle_filter/version'

Gem::Specification.new do |spec|
  spec.name          = "bundle_filter"
  spec.version       = BundleFilter::VERSION
  spec.authors       = ["Diogo Fernandes"]
  spec.email         = ["diogofernandesop@gmail.com"]

  spec.summary       = 'Filter bundle install output.'
  spec.description   = 'A filter for bundle that removes useless info when run bundle.'
  spec.homepage      = "https://github.com/dfop02/bundle_filter"
  spec.license       = "MIT"

  spec.metadata = {
    'allowed_push_host' => 'https://rubygems.org',
    'bug_tracker_uri'   => "#{spec.homepage}/issues",
    'changelog_uri'     => "#{spec.homepage}/blob/#{spec.version}/Changelog.md",
    'homepage_uri'      => spec.homepage,
    'documentation_uri' => 'https://rspec.info/documentation/',
    'source_code_uri'   => spec.homepage
  }

  spec.files            = Dir['lib/**/*']
  spec.rdoc_options     = ['--charset=UTF-8']
  spec.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md', 'LICENSE']
  spec.require_path     = 'lib'
  spec.bindir           = 'exe'
  spec.executables      = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files       = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths    = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
end
