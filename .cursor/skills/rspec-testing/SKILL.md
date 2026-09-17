---
name: rspec-testing
description: Create comprehensive unit and integration tests for Rails applications using RSpec best practices. Use when writing tests, creating specs, testing Rails models/services/jobs, or when the user asks to add RSpec tests or test coverage.
---

# RSpec Testing for Rails Applications

Create thorough, maintainable tests following Rails and RSpec best practices.

## Core Testing Principles

1. **Test behavior, not implementation**: Focus on what the code does, not how
2. **One assertion concept per test**: Tests should verify one specific behavior
3. **Arrange-Act-Assert pattern**: Set up → Execute → Verify
4. **DRY with caution**: Don't over-abstract at the expense of clarity
5. **Fast tests**: Mock external services, use database cleaner wisely

## File Organization

```
spec/
├── spec_helper.rb          # RSpec configuration
├── rails_helper.rb         # Rails-specific configuration
├── models/                 # Model unit tests
├── requests/              # Integration/API tests
├── services/              # Service object tests
├── jobs/                  # Background job tests
├── mailers/               # Mailer tests
├── factories/             # FactoryBot factories
└── support/               # Shared contexts, helpers
    ├── api_helpers.rb
    └── shared_examples/
```

## RSpec Configuration Essentials

### rails_helper.rb Setup

```ruby
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("Rails running in production!") if Rails.env.production?
require 'rspec/rails'

# Load support files
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  # Use transactional fixtures
  config.use_transactional_fixtures = true
  
  # Infer spec type from file location
  config.infer_spec_type_from_file_location!
  
  # Filter Rails backtrace
  config.filter_rails_from_backtrace!
  
  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods
  
  # Database cleaner strategy
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
```

## Unit Tests: Models

### Model Testing Structure

```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }
  
  # Associations
  describe 'associations' do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to belong_to(:organization) }
  end
  
  # Validations
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end
  
  # Instance methods
  describe '#full_name' do
    it 'returns first and last name combined' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
    
    context 'when last name is missing' do
      it 'returns only first name' do
        user = build(:user, first_name: 'John', last_name: nil)
        expect(user.full_name).to eq('John')
      end
    end
  end
  
  # Class methods / scopes
  describe '.active' do
    it 'returns only active users' do
      active_user = create(:user, active: true)
      create(:user, active: false)
      
      expect(User.active).to contain_exactly(active_user)
    end
  end
  
  # Callbacks - test behavior changes, not that callback exists
  describe 'email normalization' do
    it 'normalizes email to lowercase on save' do
      user = create(:user, email: 'TEST@Example.COM')
      expect(user.email).to eq('test@example.com')
    end
  end
end
```

### Testing Business Logic

```ruby
# spec/models/business_metric_spec.rb
require 'rails_helper'

RSpec.describe BusinessMetric, type: :model do
  describe '#calculate_growth_rate' do
    it 'calculates percentage growth correctly' do
      metric = create(:business_metric, current_value: 120, previous_value: 100)
      expect(metric.calculate_growth_rate).to eq(20.0)
    end
    
    it 'handles division by zero gracefully' do
      metric = create(:business_metric, current_value: 100, previous_value: 0)
      expect(metric.calculate_growth_rate).to be_nil
    end
    
    it 'calculates negative growth for declines' do
      metric = create(:business_metric, current_value: 80, previous_value: 100)
      expect(metric.calculate_growth_rate).to eq(-20.0)
    end
  end
end
```

## Integration Tests: Requests

Request specs test the full HTTP request/response cycle.

### Basic Request Spec Structure

```ruby
# spec/requests/api/questions_spec.rb
require 'rails_helper'

RSpec.describe 'API::Questions', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{user.api_token}" } }
  
  describe 'POST /api/questions' do
    let(:valid_params) do
      {
        question: {
          text: 'What were my sales last month?',
          phone_number: '+15555551234'
        }
      }
    end
    
    context 'with valid parameters' do
      it 'creates a new question' do
        expect {
          post '/api/questions', params: valid_params, headers: headers
        }.to change(Question, :count).by(1)
      end
      
      it 'returns 201 created status' do
        post '/api/questions', params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
      end
      
      it 'returns the created question' do
        post '/api/questions', params: valid_params, headers: headers
        json = JSON.parse(response.body)
        expect(json['text']).to eq('What were my sales last month?')
      end
      
      it 'enqueues processing job' do
        expect {
          post '/api/questions', params: valid_params, headers: headers
        }.to have_enqueued_job(ProcessQuestionJob)
      end
    end
    
    context 'with invalid parameters' do
      let(:invalid_params) { { question: { text: '' } } }
      
      it 'does not create a question' do
        expect {
          post '/api/questions', params: invalid_params, headers: headers
        }.not_to change(Question, :count)
      end
      
      it 'returns 422 unprocessable entity status' do
        post '/api/questions', params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it 'returns validation errors' do
        post '/api/questions', params: invalid_params, headers: headers
        json = JSON.parse(response.body)
        expect(json['errors']).to include('text')
      end
    end
    
    context 'without authentication' do
      it 'returns 401 unauthorized' do
        post '/api/questions', params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  
  describe 'GET /api/questions/:id' do
    let!(:question) { create(:question, user: user) }
    
    it 'returns the question' do
      get "/api/questions/#{question.id}", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(question.id)
    end
    
    context 'when question belongs to another user' do
      let(:other_question) { create(:question) }
      
      it 'returns 404 not found' do
        get "/api/questions/#{other_question.id}", headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
```

## Service Object Tests

```ruby
# spec/services/business_insight_generator_spec.rb
require 'rails_helper'

RSpec.describe BusinessInsightGenerator, type: :service do
  subject(:service) { described_class.new(user, question) }
  let(:user) { create(:user) }
  let(:question) { 'What were my sales last month?' }
  
  describe '#generate' do
    let(:ai_response) { 'Your sales last month were $10,000' }
    
    before do
      allow(OpenAI::Client).to receive_message_chain(:new, :chat)
        .and_return({ 'choices' => [{ 'message' => { 'content' => ai_response } }] })
    end
    
    it 'returns AI-generated insight' do
      expect(service.generate).to eq(ai_response)
    end
    
    context 'when AI service fails' do
      before do
        allow(OpenAI::Client).to receive(:new)
          .and_raise(OpenAI::Error.new('Service unavailable'))
      end
      
      it 'raises ServiceUnavailableError' do
        expect { service.generate }.to raise_error(
          BusinessInsightGenerator::ServiceUnavailableError
        )
      end
    end
  end
end
```

## Background Job Tests

```ruby
# spec/jobs/process_business_question_job_spec.rb
require 'rails_helper'

RSpec.describe ProcessBusinessQuestionJob, type: :job do
  let(:phone_number) { '+15555551234' }
  let(:question_text) { 'What were my sales yesterday?' }
  let(:user) { create(:user, phone_number: phone_number) }
  
  before do
    allow(BusinessInsightGenerator).to receive(:new)
      .and_return(double(generate: 'Your sales were $5,000'))
    allow(TwilioClient).to receive(:send_sms)
  end
  
  describe '#perform' do
    it 'generates insight and sends SMS response' do
      expect(BusinessInsightGenerator).to receive(:new).with(user, question_text)
      expect(TwilioClient).to receive(:send_sms).with(phone_number, 'Your sales were $5,000')
      
      described_class.perform_now(phone_number, question_text)
    end
    
    context 'when user not found' do
      it 'sends error message' do
        expect(TwilioClient).to receive(:send_sms).with(phone_number, /not registered/)
        described_class.perform_now('+15555559999', question_text)
      end
    end
    
    context 'when insight generation fails' do
      before do
        allow(BusinessInsightGenerator).to receive(:new)
          .and_raise(BusinessInsightGenerator::ServiceUnavailableError)
      end
      
      it 'sends fallback message' do
        expect(TwilioClient).to receive(:send_sms).with(phone_number, /temporarily unavailable/)
        described_class.perform_now(phone_number, question_text)
      end
    end
  end
end
```

## Shared Examples for Reusability

```ruby
# spec/support/shared_examples/api_authentication.rb
RSpec.shared_examples 'requires authentication' do |http_method, path|
  it 'returns 401 when not authenticated' do
    send(http_method, path)
    expect(response).to have_http_status(:unauthorized)
  end
end

# Usage in specs:
it_behaves_like 'requires authentication', :get, '/api/questions'
it_behaves_like 'requires authentication', :post, '/api/questions'
```

## FactoryBot Factories

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    first_name { 'John' }
    last_name { 'Doe' }
    phone_number { '+15555551234' }
    active { true }
    
    trait :inactive do
      active { false }
    end
    
    trait :with_organization do
      association :organization
    end
    
    trait :admin do
      role { :admin }
    end
  end
end

# spec/factories/questions.rb
FactoryBot.define do
  factory :question do
    association :user
    text { 'What were my sales yesterday?' }
    phone_number { '+15555551234' }
    status { :pending }
    
    trait :processed do
      status { :processed }
      response { 'Your sales yesterday were $5,000.' }
      processed_at { Time.current }
    end
  end
end
```

## Testing Best Practices Checklist

When writing tests, ensure:

- [ ] Each test has clear, descriptive name
- [ ] Tests follow Arrange-Act-Assert pattern but do not add comments like this: "Arrange", "Act", or "Assert"
- [ ] External APIs are mocked (Twilio, OpenAI, etc.)
- [ ] Tests are independent (can run in any order)
- [ ] Database is cleaned between tests
- [ ] Edge cases are covered (nil, zero, empty, invalid)
- [ ] Error cases are tested
- [ ] Authentication/authorization is tested
- [ ] Background jobs are tested
- [ ] Validations are comprehensive
- [ ] Business logic accuracy is verified

## Common RSpec Matchers

```ruby
# Equality
expect(actual).to eq(expected)
expect(actual).to eql(expected)

# Comparison
expect(actual).to be > expected
expect(actual).to be_between(1, 10)

# Collections
expect(array).to include(item)
expect(array).to contain_exactly(1, 2, 3)
expect(hash).to have_key(:name)

# Types & Classes
expect(object).to be_a(User)
expect(object).to be_an_instance_of(User)

# Truthiness
expect(value).to be_truthy
expect(value).to be_falsey
expect(value).to be_nil

# Changes
expect { action }.to change { Model.count }.by(1)
expect { action }.to change { object.status }.from(:pending).to(:completed)

# Errors
expect { action }.to raise_error(ActiveRecord::RecordNotFound)
expect { action }.not_to raise_error

# Jobs
expect { action }.to have_enqueued_job(MyJob)
expect { action }.to have_enqueued_job(MyJob).with(arg1, arg2)
