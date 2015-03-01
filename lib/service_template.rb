# require external libraries
require 'rake'
require 'dotenv'
require 'logging'
require 'octokit'
require 'grape'
require 'grape-entity'
require 'json'

# require internal files
require 'service_template/setup'
require 'service_template/version'
require 'service_template/logger/logger'
require 'service_template/logger/log_transaction'
require 'service_template/logger/parseable'
require 'service_template/identity'
require 'service_template/json_error'
require 'service_template/stats'
require 'service_template/stats_d_timer'
require 'service_template/active_record_extensions/stats'
require 'service_template/active_record_extensions/seeder'
require 'service_template/grape_extensions/error_formatter'
require 'service_template/grape_extensions/grape_helpers'
require 'service_template/output_formatters/entity'
require 'service_template/output_formatters/include_nil'
require 'service_template/output_formatters/json_api_representer'
require 'service_template/grape_extenders'
require 'service_template/middleware/logger'
require 'service_template/middleware/app_monitor'
require 'service_template/middleware/authentication'
require 'service_template/middleware/request_stats'
require 'service_template/middleware/database_stats'
require 'service_template/authentication'
require 'service_template/sortable_api'

require 'service_template/deploy'
require 'service_template/gem_dependency'

# load rake tasks if Rake installed
if defined?(Rake)
  load 'tasks/deploy.rake'
  load 'tasks/routes.rake'
end

module ServiceTemplate
  class << self
    def initialize
      unless ServiceTemplate.skip_initialization
        ServiceTemplate::Logger.logger.info ServiceTemplate::GemDependency.log_all if ServiceTemplate.env.production?
      end
    end
  end
end

ServiceTemplate.initialize
