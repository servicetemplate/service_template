require 'thor'
require 'service_template/generators'
require 'service_template/deploy'
require 'service_template/version'

ServiceTemplate.load_environment if defined?(Dotenv)

module ServiceTemplate
  class CLI
    class Generate < Thor
      register(
        Generators::ApiGenerator,
        'api',
        'api <api_name>',
        'Create a Grape API, Model and Entity'
      )

      register(
        Generators::ReadmeGenerator,
        'readme',
        'readme',
        'Create a formatted README'
      )
    end
  end

  class CLI
    class Base < Thor
      desc "version", "Shows the ServiceTemplate version number"
      def version
        say ServiceTemplate::VERSION
      end

      desc 'console [environment]', 'Start the ServiceTemplate console'
      options aliases: 'c'
      def console(environment = nil)
        ServiceTemplate.env = environment || 'development'

        require 'racksh/init'

        begin
          require "pry"
          interpreter = Pry
        rescue LoadError
          require "irb"
          require "irb/completion"
          interpreter = IRB
          # IRB uses ARGV and does not expect these arguments.
          ARGV.delete('console')
          ARGV.delete(environment) if environment
        end

        Rack::Shell.init

        $0 = "#{$0} console"
        interpreter.start
      end

      desc 'server', "Start the ServiceTemplate server"
      options aliases: 's'
      def server
        puts "ServiceTemplate server starting..."

        require 'pty'
        exit = "... ServiceTemplate server exited!"

        begin
          PTY.spawn('shotgun') do |stdout, stdin, pid|
            begin
              Signal.trap('INT') { Process.kill('INT', pid) }
              stdout.each { |line| puts line }
            rescue Errno::EIO
              puts exit
            end
          end
        rescue PTY::ChildExited
          puts exit
        end
      end

      desc 'deploy [target]', 'Deploys A Service to a given target (i.e. production, staging, etc.)'
      method_options :force => :boolean, :revision => :string, :confirm => :boolean
      def deploy(environment)
        if options[:confirm] || yes?('Are you sure you want to deploy this service?', Thor::Shell::Color::YELLOW)
          deploy = ServiceTemplate::Deploy.new(environment, force: options[:force], revision: options[:revision])
          if deploy.deployable?
            say(deploy.deploy!, Thor::Shell::Color::GREEN)
          else
            say("Deploy Failed:\n#{deploy.errors.join("\n")}", Thor::Shell::Color::RED)
          end
        end
      end

      register(
        Generators::ScaffoldGenerator,
        'new',
        'new <app_name> [app_path]',
        'Create a scaffold for a new ServiceTemplate service'
      )

      desc "generate api <api_name>", "Create a Grape API, Model and Representer"
      subcommand "generate api", ServiceTemplate::CLI::Generate

      desc "generate migration <migration_name> [field[:type][:index] field[:type][:index]]", "Create a Database Migration"
      subcommand "generate", ServiceTemplate::CLI::Generate

      desc "generate readme", "Create a formatted README"
      subcommand "generate readme", ServiceTemplate::CLI::Generate
    end
  end
end
