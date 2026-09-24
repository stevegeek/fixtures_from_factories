# frozen_string_literal: true

require "test_helper"
require "fixtures_from_factories"
require "fileutils"
require "tmpdir"

class ClassFromTableRegressionTest < ActiveSupport::TestCase
  setup do
    # Tests do not run from test/dummy, so FactoryBot's default relative paths miss the factories.
    FactoryBot.definition_file_paths = [File.expand_path("dummy/test/factories", __dir__)]
    FactoryBot.reload
  end

  test "a table whose class name does not match classify dumps its FK under the association name" do
    out = generate_fixtures do |gen|
      user = gen.create(:regression_user, :user)
      gen.create(:regression_offers_settings, :offers_settings, user: user)
    end

    row = YAML.unsafe_load_file(File.join(out, "offers_settings.yml")).fetch("regression_offers_settings")

    assert_equal "regression_user", row["user"], "expected the association-name key `user`, got: #{row.inspect}"
    assert_nil row["user_id"], "the raw `user_id` key should not be present once resolved to `user`"
  ensure
    FileUtils.remove_entry(out) if out && File.directory?(out)
  end

  test "a genuinely model-less table writes the resolved integer id under its raw _id column" do
    out = generate_fixtures do |gen|
      post_author = gen.create(:regression_post_author, :user)
      post = gen.create(:regression_post, :post, user: post_author)

      ActiveRecord::Base.connection.execute(
        "INSERT INTO post_reactions (post_id, emoji) VALUES (#{post.id}, 'tada')"
      )
    end

    rows = YAML.unsafe_load_file(File.join(out, "post_reactions.yml"))
    row = rows.fetch(rows.keys.first)

    assert_equal ActiveRecord::FixtureSet.identify("regression_post"), row["post_id"]
    assert_kind_of Integer, row["post_id"]
  ensure
    FileUtils.remove_entry(out) if out && File.directory?(out)
  end

  test "a table whose model needs the _fixture model_class header round-trips through Rails' own FixtureSet" do
    out = generate_fixtures do |gen|
      user = gen.create(:regression_user, :user)
      gen.create(:regression_offers_settings, :offers_settings, user: user)
    end

    yaml = YAML.unsafe_load_file(File.join(out, "offers_settings.yml"))
    assert_equal({"model_class" => "OffersSettings"}, yaml["_fixture"])

    # Without the header, Rails raises "table offers_settings has no columns named user".
    load_dumped_fixtures(out, ["users", "offers_settings"])

    loaded = OffersSettings.find(ActiveRecord::FixtureSet.identify("regression_offers_settings"))
    assert_equal ActiveRecord::FixtureSet.identify("regression_user"), loaded.user_id
  ensure
    FileUtils.remove_entry(out) if out && File.directory?(out)
  end

  test "a HABTM join table without its own model round-trips through Rails' own FixtureSet" do
    out = generate_fixtures do |gen|
      user = gen.create(:regression_tagged_user, :user)
      tag = gen.create(:regression_tag, :tag)
      user.tags << tag
    end

    yaml = YAML.unsafe_load_file(File.join(out, "tags_users.yml"))
    assert_nil yaml["_fixture"], "a HABTM join table must not get a model_class header"

    load_dumped_fixtures(out, ["users", "tags", "tags_users"])

    user = User.find(ActiveRecord::FixtureSet.identify("regression_tagged_user"))
    assert_equal [ActiveRecord::FixtureSet.identify("regression_tag")], user.tag_ids
  ensure
    FileUtils.remove_entry(out) if out && File.directory?(out)
  end

  private

  # create_fixtures skips tables it has already loaded, so clear its cache first.
  def load_dumped_fixtures(dir, tables)
    ActiveRecord::FixtureSet.reset_cache
    ActiveRecord::FixtureSet.create_fixtures(dir, tables)
  end

  # Builds records with a real FixtureGenerator, dumps the fixtures, then rolls back the DB.
  def generate_fixtures
    out = Dir.mktmpdir
    ActiveRecord::Base.transaction do
      gen = FixturesFromFactories::FixtureGenerator.new(out)
      yield gen
      gen.send(:dump_tables)
      gen.send(:dump_record_index)
      raise ActiveRecord::Rollback
    end
    out
  end
end
