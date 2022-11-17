# frozen_string_literal: true

require "fixtures_from_factories/fixture_generator"

module FixturesFromFactories
  class GenerateSet
    class << self
      def call(generator_index_klass, output_path, time_cop_now:, database_name:, faker_seed:, generator_options: {})
        raise "Only run fixture generation in a development environment" unless ::Rails.env.development?

        # Seed with known value to always end up with same result
        ::Faker::Config.random = Random.new(faker_seed)
        ::Faker::Config.locale = "en"

        # Freeze the time to avoid having changing timestamps when regenerating
        ::Timecop.freeze(*time_cop_now)

        # Monkey patch Devise encryptor so that we generate stable password hashes
        ::Devise::Encryptor.define_singleton_method(:digest) do |_klass, _password|
          FixturesFromFactories.configuration.devise_password_hash
        end

        # Run Seeds
        # We should use a freshly created database for the run

        # TODO: how to override the database name in dev for the next commands
        database_env_setup = "DEV_DB_NAME=#{database_name}"
        system("#{database_env_setup} bin/rails db:environment:set RAILS_ENV=development")
        system("#{database_env_setup} rake db:drop")
        system("#{database_env_setup} rake db:create")
        system("#{database_env_setup} rake db:migrate")

        # Prepare the fixture files
        ::FixtureGenerator.new(database_name, output_path).generate do
          generator_index_klass.new(self, faker_seed, generator_options).generate
        end

        # After fixtures are build the Rails env set in the DB is lost, so set it manually
        system("#{database_env_setup} bin/rails db:environment:set RAILS_ENV=development")

        ::Timecop.return
      end
    end
  end
end
