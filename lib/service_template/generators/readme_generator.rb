require 'thor'
require 'active_support/all'
require 'service_template/setup'
require 'service_template/identity'
require 'dotenv'

module ServiceTemplate
  module Generators
    class ReadmeGenerator < Thor::Group
      include Thor::Actions

      def load_environment
        ServiceTemplate.load_environment
      end

      def service_name
        ServiceTemplate::Identity.name
      end

      def routes
        routes = ""

        if defined? ApplicationApi
          ApplicationApi.routes.each do |api|
            method      = api.route_method.ljust(10)
            path        = api.route_path.ljust(40)
            description = api.route_description
            routes     += "     #{method} #{path} # #{description}"
          end
        end

        routes
      end

      def output_directory
        '.'
      end

      def readme
        self.class.source_root "#{File.dirname(__FILE__)}/templates/readme"
        say 'Generating readme...'
        directory '.', output_directory
        say 'Done!', :green
      end
    end
  end
end
