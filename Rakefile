#!/usr/bin/env rake
$LOAD_PATH.unshift 'lib', __dir__

Dir.glob('./tasks/*.rake').each { |r| import r }
require 'bundler/gem_tasks'
require 'service_template/active_record_extensions/stats.rb'
require 'service_template/active_record_extensions/seeder.rb'

task default: :spec
