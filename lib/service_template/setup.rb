# setup for service_template
# require the files that are required before everything else in service_template
# useful if you want to use any variables/methods defined here without loading the rest of service_template immediately
require 'active_support'

module ServiceTemplate
  class << self
    def load_environment
      Dotenv.load(ServiceTemplate.env.test? ? '.env.test' : '.env')
    end

    def skip_initialization
      @_skip_initialization || false
    end

    def skip_initialization=(value)
      @_skip_initialization = value if [TrueClass, FalseClass].include?(value.class)
    end

    def env
      @_env ||= ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
    end

    def env=(environment)
      @_env = ActiveSupport::StringInquirer.new(environment)
    end

    def cache
      @_cache ||= ActiveSupport::Cache.lookup_store(:memory_store)
    end

    def cache=(store_option)
      @_cache = ActiveSupport::Cache.lookup_store(store_option)
    end
  end
end
