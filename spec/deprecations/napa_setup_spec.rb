require 'spec_helper'
require 'active_support'
require 'service_template/deprecations/service_template_setup'

describe ServiceTemplate::Deprecations do
  before do
    allow(File).to receive(:exists?).and_return(true)

    @apprb_stub = [
      "require 'bundler/setup'",
      "Bundler.setup(:default)",
      "require 'service_template/setup'",
      "Bundler.require(:default, ServiceTemplate.env.to_sym)",
      "require 'service_template'",
      "ServiceTemplate.load_environment",
      "Dir['./config/initializers/**/*.rb'].map { |file| require file }",
      "Dir['./config/middleware/**/*.rb'].map { |file| require file }",
      "relative_load_paths = %w(app/apis app/entities app/models app/workers app/representers lib)",
      "ActiveSupport::Dependencies.autoload_paths += relative_load_paths"
    ]
  end

  describe '.service_template_setup_check' do
    it 'does not raise a deprecation warning if all the required_patterns are matched' do
      allow(File).to receive(:readlines).with('./app.rb').and_return(@apprb_stub)
      expect(ActiveSupport::Deprecation).to_not receive(:warn)
      ServiceTemplate::Deprecations.service_template_setup_check
    end

    it 'raises a deprecation warning if any of the required_patterns are missing' do
      (0..@apprb_stub.count - 1).each do |line_num|
        apprb_missing_line = @apprb_stub
        apprb_missing_line.delete_at(line_num)
        allow(File).to receive(:readlines).with('./app.rb').and_return(apprb_missing_line)
        expect(ActiveSupport::Deprecation).to receive(:warn)

        ServiceTemplate::Deprecations.service_template_setup_check
      end
    end

    it 'raises a deprecation warning if any of the expired_patterns are matched' do
      ServiceTemplate::Deprecations::EXPIRED_PATTERNS.each do |pattern|
        app_rb_stub = [pattern]

        allow(File).to receive(:readlines).with('./app.rb').and_return(app_rb_stub)
        expect(ActiveSupport::Deprecation).to receive(:warn)

        ServiceTemplate::Deprecations.service_template_setup_check
      end
    end
  end
end
