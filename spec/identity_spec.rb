require 'spec_helper'
require 'service_template/identity'

describe ServiceTemplate::Identity do
  context '#name' do
    it "returns 'api-service' if no ENV['SERVICE_NAME'] is set" do
      ENV['SERVICE_NAME'] = nil
      expect(ServiceTemplate::Identity.name).to eq('api-service')
    end

    it "returns the ENV['SERVICE_NAME'] when specified" do
      ENV['SERVICE_NAME'] = nil
      ENV['SERVICE_NAME'] = 'my-service'
      expect(ServiceTemplate::Identity.name).to eq('my-service')
    end
  end

  context '#hostname' do
    it 'returns the value of the hostname system call and doesn\'t make a second system call' do
      expect(ServiceTemplate::Identity).to receive(:`).with('hostname').and_return('system-hostname')
      expect(ServiceTemplate::Identity.hostname).to eq('system-hostname')

      expect(ServiceTemplate::Identity).to_not receive(:`).with('hostname')
      expect(ServiceTemplate::Identity.hostname).to eq('system-hostname')
    end
  end

  context '#revision' do
    it 'returns the value of the \'git rev-parse HEAD\' system call and doesn\'t make a second system call' do
      expect(ServiceTemplate::Identity).to receive(:`).with('git rev-parse HEAD').and_return('12345')
      expect(ServiceTemplate::Identity.revision).to eq('12345')

      expect(ServiceTemplate::Identity).to_not receive(:`).with('git rev-parse HEAD')
      expect(ServiceTemplate::Identity.revision).to eq('12345')
    end
  end

  context '#pid' do
    it 'returns the process ID value' do
      allow(Process).to receive(:pid).and_return(112233)
      expect(ServiceTemplate::Identity.pid).to eq(112233)
    end
  end

  context '#platform_revision' do
    it 'returns the current version of the platform gem' do
      expect(ServiceTemplate::Identity.platform_revision).to eq(ServiceTemplate::VERSION)
    end
  end
end
