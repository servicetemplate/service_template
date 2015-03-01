require 'spec_helper'
require 'service_template/logger/log_transaction'

describe ServiceTemplate::LogTransaction do
  before(:each) do
    ServiceTemplate::LogTransaction.clear
  end

  context '#id' do
    it 'returns the current transaction id if it has been set' do
      id = SecureRandom.hex(10)
      Thread.current[:service_template_tid] = id
      expect(ServiceTemplate::LogTransaction.id).to eq(id)
    end

    it 'sets and returns a new id if the transaction id hasn\'t been set' do
      expect(ServiceTemplate::LogTransaction.id).to_not be_nil
    end

    it 'allows the id to be overridden by a setter' do
      expect(ServiceTemplate::LogTransaction.id).to_not be_nil
      ServiceTemplate::LogTransaction.id = 'foo'
      expect(ServiceTemplate::LogTransaction.id).to eq('foo')
    end
  end

  context '#clear' do
    it 'sets the id to nil' do
      expect(ServiceTemplate::LogTransaction.id).to_not be_nil
      ServiceTemplate::LogTransaction.clear
      expect(Thread.current[:service_template_tid]).to be_nil
    end
  end
end
