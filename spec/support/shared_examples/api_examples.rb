# Shared examples for API authentication testing
RSpec.shared_examples 'requires authentication' do |http_method, path_proc|
  it 'returns 401 unauthorized when not authenticated' do
    path = path_proc.is_a?(Proc) ? instance_eval(&path_proc) : path_proc
    send(http_method, path)
    expect(response).to have_http_status(:unauthorized)
  end
end

# Shared examples for not found resources
RSpec.shared_examples 'returns not found' do |http_method, path_proc|
  it 'returns 404 not found' do
    path = path_proc.is_a?(Proc) ? instance_eval(&path_proc) : path_proc
    send(http_method, path)
    expect(response).to have_http_status(:not_found)
  end
end

# Shared examples for validating required parameters
RSpec.shared_examples 'validates required parameter' do |param_name, error_message = nil|
  it "returns 422 when #{param_name} is missing" do
    expect(response).to have_http_status(:unprocessable_entity)
    error_msg = error_message || param_name.to_s
    expect(json_response['errors']).to include(error_msg)
  end
end

# Shared examples for pagination
RSpec.shared_examples 'paginates results' do
  it 'returns pagination metadata' do
    expect(json_response).to have_key('meta')
    expect(json_response['meta']).to have_key('current_page')
    expect(json_response['meta']).to have_key('total_pages')
    expect(json_response['meta']).to have_key('total_count')
  end
end

# Shared examples for JSON API response format
RSpec.shared_examples 'returns JSON API format' do
  it 'returns JSON content type' do
    expect(response.content_type).to include('application/json')
  end

  it 'returns valid JSON' do
    expect { JSON.parse(response.body) }.not_to raise_error
  end
end
