require 'roar/decorator'
require 'roar/json/json_api'

module ServiceTemplate
  class JsonApiRepresenter < Roar::Decorator
	include Roar::JSON::JSONAPI

  end
end
