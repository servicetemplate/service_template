# -*- encoding: utf-8 -*-
require File.expand_path('../lib/service_template/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jay OConnor"]
  gem.email         = ["jay@jayoconnor.com"]
  gem.description   = %q{An opiniated lib and generator for building APIs with Grape}
  gem.summary       = %q{An easy-ish way of quickly generating an API using Grape}
  gem.homepage      = "https://github.com/jdoconnor/service_template"
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($\)
  gem.executables   << 'service_template'
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "service_template"
  gem.require_paths = ["lib"]
  gem.version       = ServiceTemplate::VERSION
  gem.required_ruby_version = '>= 2.0'


  gem.add_dependency 'rake', '~> 10.3'
  gem.add_dependency 'logging', '~> 1.8'
  gem.add_dependency 'dotenv', '~> 1.0'
  gem.add_dependency 'octokit', '~> 3.5'
  gem.add_dependency 'thor', '~> 0.19'
  gem.add_dependency 'virtus', '~> 1.0'
  gem.add_dependency 'grape', '~> 0.11.0'
  gem.add_dependency 'grape-swagger', '~> 0.8'
  gem.add_dependency 'roar', '~> 1.0.0'
  gem.add_dependency 'statsd-ruby', '~> 1.2'
  gem.add_dependency 'racksh', '~> 1.0'
  gem.add_dependency 'git', '~> 1.2'
  gem.add_dependency 'actionpack', '~> 4.2.0'

  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'pry', '~> 0.10'
  gem.add_development_dependency 'rubocop', '~> 0.25'
  gem.add_development_dependency 'activerecord', '~> 4.2.0'
  gem.add_development_dependency 'sqlite3', '~> 1.3'
  gem.add_development_dependency 'acts_as_fu', '~> 0'
  gem.add_development_dependency 'codeclimate-test-reporter'
end
