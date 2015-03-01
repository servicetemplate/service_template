# load bundler
require 'bundler/setup'
Bundler.setup(:default)
require 'service_template/setup'
Bundler.require(:default, ServiceTemplate.env.to_sym)
require 'service_template'

# load environment
ServiceTemplate.load_environment

# autoload initalizers
Dir['./config/initializers/**/*.rb'].map { |file| require file }

# load middleware configs
Dir['./config/middleware/**/*.rb'].map { |file| require file }

# autoload app
relative_load_paths = %w(app/apis app/representers app/models app/workers lib)
ActiveSupport::Dependencies.autoload_paths += relative_load_paths
