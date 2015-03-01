require 'spec_helper'
require 'service_template/middleware/request_stats'

describe ServiceTemplate::Middleware::RequestStats do
  before do
    # Delete any prevous instantiations of the emitter and set valid statsd env vars
    ServiceTemplate::Stats.emitter = nil
    ENV['STATSD_HOST'] = 'localhost'
    ENV['STATSD_PORT'] = '8125'
  end

  it 'should send the api_response_time' do
    expect(ServiceTemplate::Stats.emitter).to receive(:timing).with('response_time', an_instance_of(Float))
    expect(ServiceTemplate::Stats.emitter).to receive(:timing).with('path.get.test.path.response_time', an_instance_of(Float))
    app = lambda { |env| [200, { 'Content-Type' => 'application/json'}, Array.new] }
    middleware = ServiceTemplate::Middleware::RequestStats.new(app)
    env = Rack::MockRequest.env_for('/test/path')
    middleware.call(env)
  end

end
