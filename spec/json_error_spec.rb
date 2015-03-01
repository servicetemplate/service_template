require 'spec_helper'
require 'service_template/json_error'

describe ServiceTemplate::JsonError do
  context '#to_json' do
    it 'returns a json hash with the error data' do
      error = ServiceTemplate::JsonError.new(:code, 'message').to_json
      parsed = JSON.parse(error)

      expect(parsed['error']['code']).to eq('code')
      expect(parsed['error']['message']).to eq('message')
    end

    it 'returns a json hash with additional reasons' do
      error = ServiceTemplate::JsonError.new(:code, 'message', {foo: 'bar'}).to_json
      parsed = JSON.parse(error)

      expect(parsed['error']['code']).to eq('code')
      expect(parsed['error']['message']).to eq('message')
      expect(parsed['error']['reasons']['foo']).to eq('bar')
    end

    it 'excludes `reasons` from hash if no reasons given' do
      error = ServiceTemplate::JsonError.new(:code, 'message').to_json
      parsed = JSON.parse(error)

      expect(parsed['error']['code']).to eq('code')
      expect(parsed['error']['message']).to eq('message')
      expect(parsed['error']['reasons']).to be nil
    end

  end
end
