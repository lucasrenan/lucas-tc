module ResponseHelpers
  def parsed_response
    parse_json(response.body)
  end

  def response_data
    parsed_response['data']
  end

  def response_errors
    parsed_response['errors']
  end

  def response_meta
    parsed_response['meta']
  end
end

RSpec.configure do |config|
  config.include ResponseHelpers
end
