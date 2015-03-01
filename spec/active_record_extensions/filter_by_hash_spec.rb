require 'active_record'
require 'spec_helper'
require 'service_template/active_record_extensions/filter_by_hash'


describe ServiceTemplate::FilterByHash do
  before do
    expect(ActiveSupport::Deprecation).to receive(:warn)
    class Foo < ActiveRecord::Base; include ServiceTemplate::FilterByHash; end
  end

  context 'when a hash is provided' do
    it 'returns an AR relation' do
      expect(Foo.filter).to be_a(ActiveRecord::Relation)
    end
  end

  context 'when nothing is provided' do
    it 'returns an AR relation' do
      expect(Foo.filter).to be_a(ActiveRecord::Relation)
    end
  end
end
