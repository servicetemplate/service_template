require 'spec_helper'
require 'service_template/stats'

describe ServiceTemplate::Stats do
  before do
    # Delete any prevous instantiations of the emitter
    ServiceTemplate::Stats.emitter = nil
    # Stub out logging since there is no log to output to
    allow(ServiceTemplate::Logger).to receive_message_chain(:logger, :warn)
  end

  it 'should log an error if StatsD env variables are not configured' do
    ENV['STATSD_HOST'] = nil
    ENV['STATSD_PORT'] = nil
    message = 'StatsD host and port not configured in environment variables, using default settings'
    expect(ServiceTemplate::Logger.logger).to receive(:warn).with(message)
    ServiceTemplate::Stats.emitter
  end

  it 'should default statsd to localhost port 8125 if env vars are not specified' do
    ENV['STATSD_HOST'] = nil
    ENV['STATSD_PORT'] = nil
    expect(ServiceTemplate::Stats.emitter.host).to eq('127.0.0.1')
    expect(ServiceTemplate::Stats.emitter.port).to eq(8125)
  end

  it 'should return a StatsD client object' do
    expect(ServiceTemplate::Stats.emitter.class.name).to eq('Statsd')
  end

  it 'the namespace of the StatsD client object should equal the service name' do
    ENV['SERVICE_NAME'] = 'my-service'
    expect(ServiceTemplate::Stats.emitter.namespace).to eq("my-service.test")
  end

  it 'should use env variables to set statsd host and port' do
    ENV['STATSD_HOST']  = 'localhost'
    ENV['STATSD_PORT']  = '9000'
    expect(ServiceTemplate::Stats.emitter.host).to eq('localhost')
    expect(ServiceTemplate::Stats.emitter.port).to eq('9000')
  end

  describe '#namespace' do
    it 'prepends the namespace with the STATSD_API_KEY if present' do
      ENV['STATSD_API_KEY'] = 'foo'
      expect(ServiceTemplate::Stats.namespace).to eq("#{ENV['STATSD_API_KEY']}.#{ServiceTemplate::Identity.name}.test")
    end

    it 'does not include the STATSD_API_KEY if empty' do
      ENV['STATSD_API_KEY'] = nil
      expect(ServiceTemplate::Stats.namespace).to eq("#{ServiceTemplate::Identity.name}.test")
    end
  end

  describe '#path_to_key' do
    it 'returns the key string with ids removed and parts joined with dots' do
      method = 'GET'
      path = '/foo/123/bar'
      expect(ServiceTemplate::Stats.path_to_key(method, path)).to eq('get.foo._.bar')

      method = 'POST'
      path = '/foo'
      expect(ServiceTemplate::Stats.path_to_key(method, path)).to eq('post.foo')
    end
  end
end
