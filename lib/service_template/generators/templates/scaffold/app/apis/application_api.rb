class ApplicationApi < Grape::API
  format :json
  extend ServiceTemplate::GrapeExtenders

  mount HelloApi => '/'

  add_swagger_documentation
end

