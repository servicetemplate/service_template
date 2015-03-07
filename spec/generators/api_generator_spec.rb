require 'spec_helper'
require 'service_template/generators/api_generator'
require 'service_template/cli'

describe ServiceTemplate::Generators::ApiGenerator do
  let(:api_name) { 'foo' }
  let(:test_api_directory) { 'spec/tmp' }

  before do
    allow_any_instance_of(described_class).to receive(:output_directory).and_return(test_api_directory)
    ServiceTemplate::CLI::Base.new.generate("api", api_name)
  end

  after do
    FileUtils.rm_rf(test_api_directory)
  end

  describe 'app' do
    it 'creates an api class' do
      expected_api_file = File.join(test_api_directory, 'app/apis/foos_api.rb')
      api_code = File.read(expected_api_file)

      expect(api_code).to match(/class FoosApi/)
    end

    it 'creates a model class' do
      expected_model_file = File.join(test_api_directory, 'app/models/foo.rb')
      model_code = File.read(expected_model_file)

      expect(model_code).to match(/class Foo/)
    end

    it 'creates a representer class' do
      expected_representer_file = File.join(test_api_directory, 'app/representers/foo_representer.rb')
      representer_code = File.read(expected_representer_file)

      expect(representer_code).to match(/class FooRepresenter/)
    end

    it 'representers should inherit from ServiceTemplate::JsonApiRepresenter' do
      representer_file = File.join(test_api_directory, 'app/representers/foo_representer.rb')
      require "./#{representer_file}"
      expect(FooRepresenter.superclass).to be(ServiceTemplate::JsonApiRepresenter)
    end
  end

  describe 'spec' do
    it 'creates an api spec' do
      expected_api_file = File.join(test_api_directory, 'spec/apis/foos_api_spec.rb')
      api_code = File.read(expected_api_file)

      expect(api_code).to match(/describe FoosApi/)
    end

    it 'creates a model spec' do
      expected_model_file = File.join(test_api_directory, 'spec/models/foo_spec.rb')
      model_code = File.read(expected_model_file)

      expect(model_code).to match(/describe Foo/)
    end
  end

end
