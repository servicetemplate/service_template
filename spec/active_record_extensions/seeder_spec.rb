require 'active_record'
require 'spec_helper'
require 'service_template/active_record_extensions/seeder'

describe ServiceTemplate::ActiveRecordSeeder do

  context 'when a valid file is not provided' do
    it 'raises an exception' do
    	expect{ServiceTemplate::ActiveRecordSeeder.load_file 'not-a-file'}.to raise_error
    end
  end

end
