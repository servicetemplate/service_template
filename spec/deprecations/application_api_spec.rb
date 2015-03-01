require 'spec_helper'
require 'active_support'
require 'service_template/deprecations/application_api'

describe ServiceTemplate::Deprecations do
  describe '.application_api_check' do
    it 'does not raise a deprecation warning if the file exists' do
      allow(File).to receive(:exists?).and_return(true)
      expect(ActiveSupport::Deprecation).to_not receive(:warn)
      ServiceTemplate::Deprecations.application_api_check
    end

    it 'raises a deprecation warning if the file is missing' do
      allow(File).to receive(:exists?).and_return(false)
      expect(ActiveSupport::Deprecation).to receive(:warn)
      ServiceTemplate::Deprecations.application_api_check
    end
  end
end
