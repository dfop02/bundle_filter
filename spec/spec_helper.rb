require 'bundler'
require 'bundle_filter'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.bisect_runner = :shell

  config.expect_with :rspec do |c|
    c.syntax = :expect

    c.max_formatted_output_length = 1000
  end

  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = false
  end
end
