require 'spec_helper'
require 'service_template/output_formatters/include_nil'
require 'service_template/grape_extensions/grape_helpers'
require 'pry'

describe ServiceTemplate::Representable::IncludeNil do
  class FooRepresenter < ServiceTemplate::Representer
    include ServiceTemplate::Representable::IncludeNil
    property :foo
    property :bar
  end

  class DummyClass
    include ServiceTemplate::GrapeHelpers
  end

  it 'includes nil keys in a represented hash' do
    input = OpenStruct.new(foo: 1, bar: nil)
    output = DummyClass.new.represent(input, with: FooRepresenter).to_h
    expect(output[:data]).to have_key('foo')
    expect(output[:data]).to have_key('bar')
  end
end
