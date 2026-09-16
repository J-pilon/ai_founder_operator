require 'rails_helper'

RSpec.describe 'RSpec setup' do
  it 'loads the Rails environment' do
    expect(Rails.application).to be_a(AiConcierge::Application)
  end

  it 'connects to the test database' do
    expect(ActiveRecord::Base.connection).to be_active
  end
end
