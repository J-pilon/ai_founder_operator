# RSpec Test Suite

This directory contains the test suite for the application using RSpec.

## Structure

```
spec/
├── rails_helper.rb          # Rails-specific RSpec configuration
├── spec_helper.rb           # Base RSpec configuration
├── models/                  # Model unit tests
├── requests/               # Integration/API tests (preferred over controller tests)
├── services/               # Service object tests
├── jobs/                   # Background job tests
├── mailers/                # Mailer tests
├── factories/              # FactoryBot factory definitions (if using FactoryBot)
├── fixtures/               # Test fixtures (if needed)
└── support/                # Shared test helpers and configurations
    ├── request_spec_helper.rb
    ├── shared_examples/    # Reusable shared examples
    └── shared_contexts/    # Reusable shared contexts
```

## Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific file
bundle exec rspec spec/models/user_spec.rb

# Run specific test by line number
bundle exec rspec spec/models/user_spec.rb:23

# Run tests matching a pattern
bundle exec rspec --pattern "spec/**/*_spec.rb"

# Run with documentation format
bundle exec rspec --format documentation

# Run only failed tests from last run
bundle exec rspec --only-failures

# Run tests in random order
bundle exec rspec --order random
```

## Configuration

The test suite is configured in:
- `rails_helper.rb` - Rails-specific configurations, database setup, and gem integrations
- `spec_helper.rb` - Base RSpec configurations
- `.rspec` - Command-line options applied to every test run

## Test Helpers

### Request Spec Helper
Located in `support/request_spec_helper.rb`, provides:
- `json_response` - Parse JSON responses
- `auth_headers(user)` - Generate authentication headers
- `twilio_params` - Build Twilio webhook parameters
- `stub_valid_twilio_signature` - Mock Twilio signature validation

### Shared Examples
Located in `support/shared_examples/`:
- `requires authentication` - Test authentication requirements
- `returns not found` - Test 404 responses
- `validates required parameter` - Test parameter validation
- `returns JSON API format` - Test JSON response format

### Shared Contexts
Located in `support/shared_contexts/`:
- `with mocked Twilio` - Stub Twilio API calls
- `with mocked AI service` - Stub AI service responses
- `frozen time` - Time travel for time-dependent tests
- `with test environment variables` - Stub environment variables

## Best Practices

1. **Use request specs instead of controller specs** for integration testing
2. **Mock external services** (Twilio, OpenAI, etc.) in tests
3. **Use descriptive test names** that explain the behavior being tested
4. **Follow Arrange-Act-Assert pattern** in test structure
5. **Keep tests independent** - each test should run in isolation
6. **Test edge cases** - nil values, empty strings, zero, negative numbers
7. **Use factories over fixtures** when available
8. **Test business logic thoroughly** - accuracy is critical

## Adding Dependencies

Common testing gems to consider adding to your Gemfile:

```ruby
group :development, :test do
  gem 'rspec-rails'           # Already installed
  gem 'factory_bot_rails'     # Test data factories
  gem 'faker'                 # Generate fake data
  gem 'shoulda-matchers'      # RSpec matchers for common Rails functionality
  gem 'database_cleaner-active_record'  # Database cleaning strategies
end

group :test do
  gem 'webmock'               # Stub HTTP requests
  gem 'vcr'                   # Record HTTP interactions
  gem 'simplecov'             # Code coverage
  gem 'capybara'              # Integration testing
  gem 'selenium-webdriver'    # Browser automation
end
```

After adding gems, run `bundle install` and the `rails_helper.rb` will automatically configure them.
