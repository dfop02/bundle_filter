require_relative 'lib/bundle_filter/version'

Gem::Specification.new do |spec|
  spec.name        = 'bundle_filter'
  spec.version     = BundleFilter::VERSION
  spec.authors     = ['Diogo Fernandes']
  spec.email       = ['diogofernandesop@gmail.com']
  spec.summary     = 'Filter bundle install output.'
  spec.description = 'A filter for bundle that removes useless info when run bundle.'
  spec.homepage    = 'https://github.com/dfop02/bundle_filter'
  spec.license     = 'MIT'

  spec.metadata = {
    'allowed_push_host' => 'https://rubygems.org',
    'bug_tracker_uri' => "#{spec.homepage}/issues",
    'changelog_uri' => "#{spec.homepage}/blob/#{spec.version}/Changelog.md",
    'homepage_uri' => spec.homepage,
    'documentation_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'rubygems_mfa_required' => 'true'
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.rdoc_options     = ['--charset=UTF-8']
  spec.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md', 'LICENSE']
  spec.require_path     = 'lib'
  spec.bindir           = 'exe'
  spec.executables      = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths    = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')
end
