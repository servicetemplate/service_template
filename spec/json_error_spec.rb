require 'spec_helper'
require 'service_template/json_error'

describe ServiceTemplate::JsonError do
  context '#to_json' do
    it 'returns a json hash with the error data' do
      error = ServiceTemplate::JsonError.new(:code, 'message').to_json
      parsed = JSON.parse(error)

      expect(parsed['error']['code']).to eq('code')
      expect(parsed['error']['detail']).to eq('message')
    end
  end
end
