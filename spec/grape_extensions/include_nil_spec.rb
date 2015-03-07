require 'spec_helper'
require 'service_template/output_formatters/include_nil'
require 'service_template/grape_extensions/grape_helpers'

describe ServiceTemplate::Representable::IncludeNil do
  class FooRepresenter < ServiceTemplate::JsonApiRepresenter
    include ServiceTemplate::Representable::IncludeNil
    property :foo
    property :bar
  end

  class DummyClass
    include ServiceTemplate::GrapeHelpers
  end

  xit 'includes nil keys in a represented hash' do
    input = OpenStruct.new(foo: 1, bar: nil)
    output = DummyClass.new.represent(input, with: FooRepresenter).to_h
    expect(output[:data]).to have_key('foo')
    expect(output[:data]).to have_key('bar')
  end
end
