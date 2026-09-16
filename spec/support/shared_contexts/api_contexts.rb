# Shared context for mocking external API services
RSpec.shared_context 'with mocked Twilio' do
  let(:twilio_client) { instance_double(Twilio::REST::Client) }
  let(:twilio_messages) { instance_double(Twilio::REST::Api::V2010::AccountContext::MessageList) }

  before do
    allow(Twilio::REST::Client).to receive(:new).and_return(twilio_client)
    allow(twilio_client).to receive(:messages).and_return(twilio_messages)
    allow(twilio_messages).to receive(:create).and_return(
      double(sid: 'SM1234567890', status: 'queued')
    )
  end
end

# Shared context for mocking OpenAI/AI services
RSpec.shared_context 'with mocked AI service' do
  let(:ai_response) { 'Your sales last month were $10,000 with 20% growth.' }

  before do
    # Adjust this based on your actual AI service implementation
    allow_any_instance_of(BusinessInsightGenerator).to receive(:generate).and_return(ai_response)
  end
end

# Shared context for time-frozen tests
RSpec.shared_context 'frozen time' do |time_string = '2024-01-15 12:00:00 UTC'|
  let(:frozen_time) { Time.zone.parse(time_string) }

  around do |example|
    travel_to(frozen_time) do
      example.run
    end
  end
end

# Shared context for stubbing environment variables
RSpec.shared_context 'with test environment variables' do
  around do |example|
    ClimateControl.modify(
      TWILIO_ACCOUNT_SID: 'test_account_sid',
      TWILIO_AUTH_TOKEN: 'test_auth_token',
      TWILIO_PHONE_NUMBER: '+15555550000',
      OPENAI_API_KEY: 'test_openai_key'
    ) do
      example.run
    end
  end
end
