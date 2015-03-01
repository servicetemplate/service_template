require 'erb'
db = YAML.load(ERB.new(File.read('./config/database.yml')).result)[ServiceTemplate.env]
ActiveRecord::Base.establish_connection(db)
ActiveRecord::Base.logger = ServiceTemplate::Logger.logger if ServiceTemplate.env.development?
ActiveRecord::Base.include_root_in_json = false
