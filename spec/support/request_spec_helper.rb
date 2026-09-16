# Helper methods for request specs
module RequestSpecHelper
  # Parse JSON response body
  def json_response
    JSON.parse(response.body)
  end

  # Create authorization header
  def auth_headers(user)
    token = user.api_token || generate_token_for(user)
    { 'Authorization' => "Bearer #{token}" }
  end

  # Helper to generate API token if needed
  def generate_token_for(user)
    # Implement your token generation logic here
    # Example: JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
    "test_token_#{user.id}"
  end

  # Helper for Twilio webhook params
  def twilio_params(phone_number:, body:, message_sid: 'SM1234567890')
    {
      From: phone_number,
      To: '+15555550000',
      Body: body,
      MessageSid: message_sid,
      AccountSid: 'AC1234567890'
    }
  end

  # Stub Twilio signature validation
  def stub_valid_twilio_signature
    allow_any_instance_of(TwilioAuthenticator).to receive(:valid_signature?).and_return(true)
  end

  def stub_invalid_twilio_signature
    allow_any_instance_of(TwilioAuthenticator).to receive(:valid_signature?).and_return(false)
  end
end

RSpec.configure do |config|
  config.include RequestSpecHelper, type: :request
end
