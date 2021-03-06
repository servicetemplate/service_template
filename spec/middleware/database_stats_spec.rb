require 'active_record'
require 'spec_helper'
require 'service_template/active_record_extensions/stats'

# Delete any prevous instantiations of the emitter and set valid statsd env vars
ServiceTemplate::Stats.emitter = nil
ENV['STATSD_HOST'] = 'localhost'
ENV['STATSD_PORT'] = '8125'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define(version: 1) do
  create_table :foos do |t|
    t.string :word
  end
end

class Foo < ActiveRecord::Base
end

describe ServiceTemplate::Middleware::DatabaseStats do
  before do
    # Delete any prevous instantiations of the emitter and set valid statsd env vars
    ServiceTemplate::Stats.emitter = nil
    ENV['STATSD_HOST'] = 'localhost'
    ENV['STATSD_PORT'] = '8125'

    @foo = Foo.create(word: 'bar')
  end

  after do
    middleware = ServiceTemplate::Middleware::DatabaseStats.new(@app)
    env = Rack::MockRequest.env_for('/test/path')
    middleware.call(env)
  end

  it 'should send a query_time for an insert' do
    allow(ServiceTemplate::Stats.emitter).to receive(:timing).with('sql.query_time', an_instance_of(Float))
    allow(ServiceTemplate::Stats.emitter).to receive(:timing).with('sql.table.foos.insert.query_time', an_instance_of(Float))

    @app = lambda { |env| [200, { 'Content-Type' => 'application/json' }, Foo.create(word: 'baz')] }
  end

  it 'should send a query_time for a select' do
    allow(ServiceTemplate::Stats.emitter).to receive(:timing).with('sql.query_time', an_instance_of(Float))
    allow(ServiceTemplate::Stats.emitter).to receive(:timing).with('sql.table.foos.select.query_time', an_instance_of(Float))

    @app = lambda { |env| [200, { 'Content-Type' => 'application/json' }, Foo.first] }
  end

  it 'should send a query_time for a delete' do
    allow(ServiceTemplate::Stats.emitter).to receive(:timing).with('sql.query_time', an_instance_of(Float))
    allow(ServiceTemplate::Stats.emitter).to receive(:timing).with('sql.table.foos.delete.query_time', an_instance_of(Float))

    @app = lambda { |env| [200, { 'Content-Type' => 'application/json' }, @foo.delete ] }
  end

  it 'should send a query_time for an update' do
    allow(ServiceTemplate::Stats.emitter).to receive(:timing).with('sql.query_time', an_instance_of(Float))
    allow(ServiceTemplate::Stats.emitter).to receive(:timing).with('sql.table.foos.update.query_time', an_instance_of(Float))

    @app = lambda { |env| [200, { 'Content-Type' => 'application/json' }, @foo.update_attributes(word: 'baz') ] }
  end
end
