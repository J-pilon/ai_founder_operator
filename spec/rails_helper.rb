# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = Rails.root.join('spec/fixtures')

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Include FactoryBot syntax methods (if using FactoryBot)
  begin
    require 'factory_bot_rails'
    config.include FactoryBot::Syntax::Methods
  rescue LoadError
    # FactoryBot not installed
  end

  # Shoulda Matchers configuration (if using shoulda-matchers)
  begin
    require 'shoulda/matchers'
    Shoulda::Matchers.configure do |shoulda_config|
      shoulda_config.integrate do |with|
        with.test_framework :rspec
        with.library :rails
      end
    end
  rescue LoadError
    # Shoulda Matchers not installed
  end

  # Database Cleaner configuration (if using database_cleaner)
  begin
    require 'database_cleaner/active_record'

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end
  rescue LoadError
    # DatabaseCleaner not installed, using Rails' default transactional fixtures
  end

  # Configure SimpleCov for code coverage (if using simplecov)
  begin
    require 'simplecov'
    SimpleCov.start 'rails' do
      add_filter '/spec/'
      add_filter '/config/'
      add_filter '/vendor/'

      add_group 'Controllers', 'app/controllers'
      add_group 'Models', 'app/models'
      add_group 'Services', 'app/services'
      add_group 'Jobs', 'app/jobs'
      add_group 'Mailers', 'app/mailers'
    end
  rescue LoadError
    # SimpleCov not installed
  end

  # Stub external HTTP requests (if using WebMock)
  begin
    require 'webmock/rspec'
    WebMock.disable_net_connect!(allow_localhost: true)
  rescue LoadError
    # WebMock not installed
  end

  # VCR configuration for recording HTTP interactions (if using VCR)
  begin
    require 'vcr'
    VCR.configure do |vcr_config|
      vcr_config.cassette_library_dir = 'spec/vcr_cassettes'
      vcr_config.hook_into :webmock
      vcr_config.configure_rspec_metadata!
      vcr_config.ignore_localhost = true

      # Filter sensitive data from cassettes
      vcr_config.filter_sensitive_data('<TWILIO_ACCOUNT_SID>') { ENV['TWILIO_ACCOUNT_SID'] }
      vcr_config.filter_sensitive_data('<TWILIO_AUTH_TOKEN>') { ENV['TWILIO_AUTH_TOKEN'] }
      vcr_config.filter_sensitive_data('<OPENAI_API_KEY>') { ENV['OPENAI_API_KEY'] }
    end
  rescue LoadError
    # VCR not installed
  end

  # Configure ActionMailer for testing
  config.before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  # Configure ActiveJob for testing
  config.before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  # Time helpers for time-dependent tests
  config.include ActiveSupport::Testing::TimeHelpers

  # Request spec helpers
  config.include RequestSpecHelper, type: :request if defined?(RequestSpecHelper)

  # Custom configuration

  # Reset sequences between tests to ensure consistent test data
  config.before(:each) do
    # Add any custom before hooks here
  end

  config.after(:each) do
    # Add any custom after hooks here
  end

  # Shared examples and contexts
  # These will be automatically loaded from spec/support/shared_examples
  # and spec/support/shared_contexts

  # Example: Uncomment to enable focus mode (run only tests tagged with :focus)
  # config.filter_run_when_matching :focus

  # Example: Profile slow tests
  # config.profile_examples = 10

  # Example: Randomize test order
  # config.order = :random
  # Kernel.srand config.seed
end
