# frozen_string_literal: true

require "fixtures_from_factories"

class DemoFixturesBuilder < FixturesFromFactories::BaseBuilder
  def generate
    # Add data that was seeded (already in newly created database) to fixtures
    # Here the Category records will be added with names "category_<id>"
    generator.add_collection(Category.all)
    # Here the tag records will be added with names "tag_<name attribute parameterized and underscored>"
    # eg a Tag(name: "Foo Bar") will be added as "tag_foo_bar"
    generator.add_collection(Tag.all) { |t| t.name.parameterize.underscore }

    # Setup for tables with no primary key ID (eg joins tables), note must have an AR model class
    generator.configure_name(CategoriesPost, :category_id, :post_id)
    generator.configure_name(PostsTag, :tag_id, :post_id)

    # Create an author
    author = generator.create(
      :first_author, # name of the fixture
      :user, # factory name
      :with_long_name # optional traits
    )

    generator.create(
      :second_author,
      :user,
      name: "John" # optional attributes
    )

    # Create 6 blog posts for the author - will be named "first_author_post_1", "first_author_post_2", etc
    generator.create_multiple(:first_author_post, :post, 1, 6) do |post_index|
      # from the block return the attributes for the factory
      {
        user: author,
        title: Faker::Lorem.sentence(word_count: 3),
        published_at: generator.make_fake_time(post_index.days.ago, (post_index - 1).days.ago)
      }
    end

    generator.create(
      :second_author_post,
      :post,
      title: "My first post",
      user: generator.get(:second_author),
      published_at: generator.make_fake_time(1.year.ago, 1.hour.ago)
    )

    generator.create(
      :category_to_post,
      :categories_post,
      category: generator.get(:category_2), # You can get a previously created record using its name
      post: generator.get(:first_author_post_1)
    )

    generator.create(
      :tag_to_post,
      :posts_tag,
      tag: generator.get(:tag_refactoring),
      post: generator.get(:first_author_post_1)
    )
  end
end

::FixturesFromFactories::GenerateSet.call(
  DemoFixturesBuilder, # The custom class which will setup the data
  Rails.root.join("fixtures"), # path to the directory where the fixtures will be written, eg Rails.root.join("demos", "fixtures")
  time_cop_now: [2021, 11, 9, 12, 45, 0], # The time to freeze "now" to
  faker_seed: 42, # A seed value for faker to ensure consistent data between runs
  options: { # Any options to pass to the data builder class, available as `options` in the builder class
    # ...
  }
)
