require 'spec_helper'
require 'service_template/grape_extensions/error_formatter'

describe Grape::ErrorFormatter::Json do
  context '#call' do
    it 'returns an api_error for plain error messages' do
      error = Grape::ErrorFormatter::Json.call('test message', nil)
      parsed = JSON.parse(error)
      expect(parsed['error']['code']).to eq('api_error')
      expect(parsed['error']['message']).to eq('test message')
    end

    it 'returns a specified error when given a ServiceTemplate::JsonError object' do
      json_error = ServiceTemplate::JsonError.new(:foo, 'bar')
      error = Grape::ErrorFormatter::Json.call(json_error, nil)
      parsed = JSON.parse(error)
      expect(parsed['error']['code']).to eq('foo')
      expect(parsed['error']['message']).to eq('bar')
    end

    it 'adds the backtrace with rescue_option[:backtrace] specified' do
      error = Grape::ErrorFormatter::Json.call('',
                                               'backtrace',
                                               rescue_options: {backtrace: true})
      parsed = JSON.parse(error)
      expect(parsed['backtrace']).to eq('backtrace')
    end
  end
end
