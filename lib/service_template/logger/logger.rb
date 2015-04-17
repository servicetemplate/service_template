module ServiceTemplate
  class Logger
    class << self
      def name
        [ServiceTemplate::Identity.name, ServiceTemplate::LogTransaction.id].join('-')
      end

      def logger=(logger)
        @logger = logger
      end

      def logger
        unless @logger
          Logging.appenders.stdout(
            'stdout',
            layout: Logging.layouts.json
          )
          Logging.appenders.file(
            "log/#{ServiceTemplate.env}.log",
            layout: Logging.layouts.json
          )

          @logger = Logging.logger["[#{name}]"]
          @logger.add_appenders 'stdout' unless ServiceTemplate.env.test?
        end

        @logger
      end

      def log_file=(filename)
        @logger.add_appenders filename
      end

      def response(status, headers, body)
        { response:
          {
            status:   status,
            headers:  headers,
            response: body
          }
        }
      end
    end
  end
end
