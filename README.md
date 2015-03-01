THIS IS A FORK and different opinions of a VERY good framwork called Napa
https://github.com/bellycard/napa

Here are the main differences
+ Roar with hypermedia JSON-API default rather than a bespoke response format
+ ActiveRecord 4.2 rather than 4.0
+ Rollbar rather than Honeybadger

## Installation

ServiceTemplate is available as a gem, to install it run:

```
gem install service_template
```

Or, if you're using Bundler, add it to your Gemfile:

```
gem 'service_template'
```

And run:

```
$ bundle install
```

## Getting Started

See the [Quickstart Guide](https://github.com/bellycard/service_template/blob/master/docs/quickstart.md) for an intro to creating a simple service with ServiceTemplate.

## Usage

Run `service_template` terminal prompt to see available features:

```
Commands:
  service_template console [environment]                                                            # Start the ServiceTemplate console
  service_template server                                                                           # Start the ServiceTemplate server
  service_template generate api <api_name>                                                          # Create a Grape API, Model and Representer
  service_template generate migration <migration_name> [field[:type][:index] field[:type][:index]]  # Create a Database Migration
  service_template generate readme                                                                  # Create a formatted README
  service_template deploy <environment>                                                             # Deploy to <environment> by setting a git tag
  service_template help [COMMAND]                                                                   # Describe available commands or one specific command
  service_template new <app_name> [app_path]                                                        # Create a scaffold for a new ServiceTemplate service
  service_template version                                                                          # Shows the ServiceTemplate version number
```


### Console
Similar to the Rails console, load an IRB session with your applications environment by running:

```
service_template console
```

### Deploy
ServiceTemplate provides a CLI for deploying to a given environment by setting a git tag. This is useful for chef-based deploys where deploys are trigged when a git SHA changes.

```sh
service_template deploy production
Are you sure you want to deploy this service? Y
#=> <git SHA> tagged as production by danielmackey at October 09, 2014 14:41
```

If you want to skip the 'Are you sure?' prompt, pass the `--confirm` flag to set the tag automatically
```sh
service_template deploy production --confirm
#=> <git SHA> tagged as production by danielmackey at October 09, 2014 14:41
```

### Rake Tasks

`rake -T` will give you a list of all available rake tasks:

```
rake db:create          # Create the database
rake db:drop            # Delete the database
rake db:migrate         # Migrate the database through scripts in db/migrate
rake db:reset           # Create the test database
rake db:schema:dump     # Create a db/schema.rb file that can be portably used against any DB supported by AR
rake db:schema:load     # Load a schema.rb file into the database
rake db:seed            # Load the seed data from db/seeds.rb
rake git:set_tag[tag]   # Set tag, which triggers deploy
rake git:verify         # Verify git repository is in a good state for deployment
rake routes             # display all routes for Grape
```

## Middlewares
ServiceTemplate includes a number of Rack middlewares that can be enabled to add functionality to your project.

### Authentication
The Authentication middleware will add a simple header based authentication layer to all requests. This is just looking for a header of `'Password' = 'Your Password'`. The passwords are defined in the `.env` file. You can allow multiple passwords by supplying a comma separated list. For example:

`HEADER_PASSWORDS='password1,password2'`

If your application doesn't require authentication, you can simply remove the middleware.

### Health Check
The Health Check middleware will add an endpoint at `/health` that will return some data about your app. This was created to allow monitoring tools a standardized way to monitor multiple services. This endpoint will return a response similar to this:

```
{
    "name": "service-name",
    "hostname": "host-name",
    "revision": "current-git-sha-of-app",
    "pid": 1234,
    "parent_pid": 1233,
    "service_template_revision": "running-version-of-service_template"
}
```

### Logger
The *Logger* module is used to create a common log format across applications. The Logger is enable via a rack middleware by adding the line below to your `config.ru` file:

```ruby
use ServiceTemplate::Middleware::Logger
```

You can also enable the logger for ActiveRecord by adding the following line to an initializer:

```ruby
ActiveRecord::Base.logger = ServiceTemplate::Logger.logger
```

`ServiceTemplate::Logger.logger` returns a Singleton instance of the Logging object, so it can be passed to other libraries or called directly. For example:

```ruby
ServiceTemplate::Logger.logger.debug 'Some Debug Message'
```

### Scrubbing Logs of Sensitive Data

Some requests may contain sensitive information, such as passwords or credit card numbers. In order to protect this information, they should be filtered out from logs.

To do so, add the following line to an initializer:
```ruby
ServiceTemplate::ParamSanitizer.filter_params = [:password, :password_confirmation, :cvv, :card_number]
```
Note that the keys in the array above are just examples. They should be replaced with the parameters that have sensitive data in their value.

Example **unfiltered** request ( ... denotes other information):
```
{ ... "message":{"request":{"method":"POST","path":"/example","query":"name=Test%20User%200039\u0026password=password", ... "params":{"name":"Test User 0039","password":"password"} ...}}}
```

Example **filtered** request ( ... denotes other information):
```
{ ... "message":{"request":{"method":"POST","path":"/example","query":"name=Test%20User%200039\u0026password=[FILTERED]", ... "params":{"name":"Test User 0039","password":"[FILTERED]"} ...}}}
```

### StatsD
There are two middlewares available to enable StatsD reporting, `RequestStats` and `DatabaseStats`. They can be enabled independently in your `config.ru` file:

```
use ServiceTemplate::Middleware::RequestStats
use ServiceTemplate::Middleware::DatabaseStats
```

**RequestStats** will emit information about your application's request count and response time.

**DatabaseStats** will emit information from ActiveRecord about query times.

##### Configuration

To configure StatsD in your application you will need to supply the `STATSD_HOST` and `STATSD_PORT` in your environment. Optionally, if your StatsD host requires an api token (i.e. hostedgraphite), you can configure that with the `STATSD_API_KEY` environment variable.

##### Logging

If you want to see the StatsD reporting in action you can hook up the logger to the ServiceTemplate logger to see the requests in your logs.

```
Statsd.logger = ServiceTemplate::Logger.logger
```

### Caching

ServiceTemplate adds a simple wrapper around `ActiveSupport::Cache` that allows you to easily access it similar to how it works in Rails. `ServiceTemplate.cache` will give you access to all of the methods available in `ActiveSupport::Cache::Store` [http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html](). So, for example:

```
ServiceTemplate.cache.read
ServiceTemplate.cache.write
ServiceTemplate.cache.fetch
...
```

By default it will use `:memory_store`, but you can override it to use any other caching strategy, like Memcache by setting the store:

```
ServiceTemplate.cache = :dalli_store
```

### Sorting

ServiceTemplate has an optional module you can include in any Api called
`ServiceTemplate::SortableApi`. To include this, add `include SortableApi` in the
`helpers` block of the Api.

`SortableApi` takes in a parameter for sort in the format of
`field1,field2,-field3`, where `field1` and `field2` are used to sort
ascending, and `field3` is sorted descending. For example,
`-field4,field1` would be equivalent to `ORDER BY field4 DESC, field1'.

Call `sorted_from_params(ar_relation, params[:sort])` passing in an
`ActiveRecord::Relation` for `ar_relation`, and a comma-delimited string of field names for `params[:sort]`.

## Bugs & Feature Requests
Please add an issue in [Github](https://github.com/bellycard/service_template/issues) if you discover a bug or have a feature request.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
