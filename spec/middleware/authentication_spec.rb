require 'spec_helper'
require 'service_template/middleware/authentication'
require 'pry'

describe ServiceTemplate::Identity do
  before do
    ENV['HEADER_PASSWORDS'] = 'foo'
  end

  context 'Authenticated Request' do
    it 'allows the request to continue if given a correct password header' do
      app = lambda { |env| [200, {'Content-Type' => 'application/json'}, Array.new] }
      middleware = ServiceTemplate::Middleware::Authentication.new(app)
      env = Rack::MockRequest.env_for('/test', {'HTTP_PASSWORD' => 'foo'})
      status, headers, body = middleware.call(env)

      expect(status).to eq(200)
    end
  end

  context 'Failed Authentication Request' do
    it 'returns an error message if the Password header is not supplied' do
      app = lambda { |env| [200, {'Content-Type' => 'application/json'}, Array.new] }
      middleware = ServiceTemplate::Middleware::Authentication.new(app)
      env = Rack::MockRequest.env_for('/test')
      status, headers, body = middleware.call(env)

      expect(status).to eq(401)
      expect(body).to eq([ServiceTemplate::JsonError.new('bad_password', 'bad password').to_json])
    end

    it 'returns an error message if an incorrect Password header is supplied' do
      app = lambda { |env| [200, {'Content-Type' => 'application/json'}, Array.new] }
      middleware = ServiceTemplate::Middleware::Authentication.new(app)
      env = Rack::MockRequest.env_for('/test', {'HTTP_PASSWORD' => 'incorrect'})
      status, headers, body = middleware.call(env)

      expect(status).to eq(401)
      expect(body).to eq([ServiceTemplate::JsonError.new('bad_password', 'bad password').to_json])
    end

    it 'returns an error message if HEADER_PASSWORDS is not configured' do
      ENV['HEADER_PASSWORDS'] = nil

      app = lambda { |env| [200, {'Content-Type' => 'application/json'}, Array.new] }
      middleware = ServiceTemplate::Middleware::Authentication.new(app)
      env = Rack::MockRequest.env_for('/test', {'HTTP_PASSWORD' => 'incorrect'})
      status, headers, body = middleware.call(env)

      expect(status).to eq(401)
      expect(body).to eq([ServiceTemplate::JsonError.new('not_configured', 'password not configured').to_json])
    end
  end
end
