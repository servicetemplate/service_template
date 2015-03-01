require 'spec_helper'
require 'service_template/stats_d_timer'

class FooTimer
  include ServiceTemplate::StatsDTimer
end

describe ServiceTemplate::StatsDTimer do
  before do
    # Delete any prevous instantiations of the emitter
    ServiceTemplate::Stats.emitter = nil
    # Stub out logging since there is no log to output to
    allow(ServiceTemplate::Logger).to receive_message_chain(:logger, :warn)
  end

  it 'logs a timing event based on how long the block takes' do
    expect(ServiceTemplate::Stats.emitter).to receive(:timing).with('foo', an_instance_of(Float))
    FooTimer.report_time('foo') do
      sleep(0.1)
    end
  end

end
