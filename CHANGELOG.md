master
===
* [Explicitly require `filter_parameters.rb` instead of relying on `action_dispatch` autoload](https://github.com/bellycard/service_template/pull/181)
* [Default rake task runs specs](https://github.com/bellycard/service_template/pull/176)
* [Set ServiceTemplate.env to the environment arg we pass in the console](https://github.com/bellycard/service_template/pull/179)
* [Add thor command to start shotgun server](https://github.com/bellycard/service_template/pull/177)

0.4.1
===
* Added a reasons object to error responses to represent active record validation errors for individual attributes
* Added ability to filter sensitive data from logs.

0.4.0
===
* Added `ServiceTemplate.cache` to wrap `ActiveSupport::Cache`
* Added README generator
* Update the HoneyBadger scaffolding
* Fixed a bug with ServiceTemplate::StatsDTimer where time was being reported in seconds, not milliseconds
* Removed additional StatsD counter metric for request stats middleware
* Added new deploy CLI with `force` and `revision` options `service_template deploy production`
* Added deprecation warnings
* Added initialization hook to run code when a ServiceTemplate service boots
* Added Migration generators from Rails
* Added rake db:seed functionality
* Added some convenience methods to spec_helper

0.3.0
===
* Added `rake db:rollback` to rollback migrations just like Rails
* Fixed bug in migration generator causing constant not defined errors
* Fixed CORS config in scaffold generator
* Fixed logging bug in grape_extenders
* Set UTF-8 encoding in generated database.yml
* Removed unneeded gem dependencies (shotgun and unicorn)
* Fixed spec_helper that gets generated to ignore spec files and gems (on CI servers)
* Added spec response helpers `parsed_response`, `response_code` and `response_body` to make tests easier to DRY up
* Removed #filter and `include ServiceTemplate::FilterByHash` from generated code.
* Fix when using IRB and service_template console
* Added IncludeNil module for Representable/Roar output
* Template updates to include spec files for APIs
* Removing FilterByHash in the API template
* Fix when ErrorFormatter is passed a non-hash
* Added more descriptive messages on git based deploy errors
* Added RequestStats and DatabaseStats middlewares to report data to StatsD
* All String logs are now wrapped in a hash before being written to the log file

0.2.1
===
* Updated ServiceTemplate console. It now takes an optional environment parameter, i.e. `service_template console production`.
* Added `c` alias for ServiceTemplate console, i.e. `service_template c` or `service_template c production`
* Fixed a bug causing `rake db:schema:load` to fail
* Fixed a bug affecting `rake db:create` and `rake db:drop` using Postgres
* Fixed a bug ServiceTemplate::GrapeHelpers to bypass the representer when given an array

0.2.0
===
* The console is now run with `service_template console`, added support for racksh
* Scaffold generator now supports the `--database (-d)` flag
* Scaffold generator now supports Mysql or Postgres with ActiveRecord
* Scaffold generator now uses Roar instead of Grape Entity
* Fixed a bug in `rake routes`
* Fixed a bug in `rake db:reset`
* Added StatsD instrumentation (experimental)
* Added a CHANGELOG
