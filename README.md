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

Write a script (rake task or otherwise) which calls `GenerateSet` and gives it the name of a class which exposes
a "generate" method. This class should be a subclass of `FixturesFromFactories::BaseBuilder` and should

```ruby
FixturesFromFactories::GenerateSet.call(
  DemoFixturesBuilder, # The custom class which will setup the data
  fixtures_path, # path to the directory where the fixtures will be written, eg Rails.root.join("demos", "fixtures")
  time_cop_now: [Time.zone.now], # The time to freeze "now" to
  faker_seed: 42, # A seed value for faker to ensure consistent data between runs
  options: { # Any options to pass to the data builder class, available as `options` in the builder class
    # ...
  }
)
```

The `DemoFixturesBuilder` class should look something like this:

```ruby
class DemoFixturesBuilder < FixturesFromFactories::BaseBuilder
  def generate
    # Add data that was seeded (already in newly created database) to fixtures
    # Here the Category records will be added with names "category_<id>"
    generator.add_collection(Category.all)
    # Here the tag records will be added with names "tag_<name attribute parameterized and underscored>"
    # eg a Tag(name: "Foo Bar") will be added as "tag_foo_bar"
    generator.add_collection(Tag.all) { |t| t.name.parameterize.underscore }
    
    # Setup for tables with no primary key ID (eg joins tables), note must have an AR model class
    generator.configure_name(CategoriesPosts, :category_id, :post_id)

    # Create an author
    author = generator.create(
      :first_author, # name of the fixture
      :user, # factory name
      :with_comments,  # optional traits
      first_name: "John", # optional attributes
      last_name: "Doe"
    )
    
    # Create 6 blog posts for the author - will be named "first_author_post_1", "first_author_post_2", etc
    generator.create_multiple(:first_author_post, :post, 1, 6) do |post_index|
      # from the block return the attributes for the factory
      {
        author: author, # or generator.get(:first_author)
        text: Faker::Lorem.paragraphs(number: 3).join("\n\n"),
        published_at: generator.make_fake_time(post_index.days.ago, (post_index - 1).days.ago)
      }
    end
    
    generator.create(
      :category_to_post, 
      :categories_post, 
      category: generator.get(:category_12), # You can get a previously created record using its name
      post: generator.get(:first_author_post_1)
    )
    
    # ... etc
  end
end
```


To load the generated fixtures to your DB

    rake db:fixtures:load FIXTURES_PATH=demos/fixtures

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
