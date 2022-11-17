# FixturesFromFactories

A tool to help build a set of Fixtures for your Rails app, using your test suite's FactoryBot factories. 

## Why? 

So you can build a full set of "fake data" for your development environment or for your QA/demo or test environments.

Instead of manually maintaining a set of fixtures you can write a script which uses you existing Factories to 
build out the data set. Ie we generate fixture files from a script which uses FactoryBot factories to define the setup.

`FixturesFromFactories` sets up a clean DB, runs your setup script, and then dumps records to fixture YAML files!

Your Fixtures can then be very quickly loaded into the database to setup a new dev env with data to work with, or 
reset a demo environment between demos to prospective clients.

Features:
- TODO

## Prior art (`fixture-builder` gem)

The logic to dump the entities to YAML is based partly on [fixture-builder](https://github.com/rdy/fixture_builder).

Big thanks to the many contributors to that project.


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add fixtures_from_factories

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install fixtures_from_factories

## Usage

TODO: Write usage instructions here



To load the fixtures to your DB

    rake db:fixtures:load

*NOTE:* if you are adding something where the records have no primary 'id' key (eg on HABTM joins table) you must
specify the columns to use when comparing records in the generator. Ie you must specify a set of attributes
which uniquely identify each row (for example in a join table the pair of IDs in the row). This is done in
`TestFixturesGenerators::Index` at the start of the model generation process.



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fixtures_from_factories.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
