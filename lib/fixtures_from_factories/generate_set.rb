# frozen_string_literal: true

require_relative "./fixture_generator"
require "timecop"

module FixturesFromFactories
  class GenerateSet
    class << self
      def call(generator_index_klass, output_path, time_cop_now:, faker_seed:, options: {})
        raise "Do not run fixture generation in a production environment" if ::Rails.env.production?

        # Seed with known value to always end up with same result
        ::Faker::Config.random = Random.new(faker_seed)
        ::Faker::Config.locale = "en"

        # Freeze the time to avoid having changing timestamps when regenerating
        ::Timecop.freeze(*time_cop_now)

        # TODO: what is a better solution here?
        # Monkey patch Devise encryptor so that we generate stable password hashes
        if defined?(Devise)
          ::Devise::Encryptor.define_singleton_method(:digest) do |_klass, _password|
            FixturesFromFactories.configuration.devise_password_hash
          end
        end

        database_env_setup = "RAILS_ENV=#{ENV["RAILS_ENV"]}"
        puts "Setup database for fixtures #{database_env_setup}"
        system("#{database_env_setup} bin/rails db:environment:set RAILS_ENV=development")
        # TODO: should we just use db:reset here?
        system("#{database_env_setup} rake db:drop")
        system("#{database_env_setup} rake db:create")
        system("#{database_env_setup} rake db:migrate")
        system("#{database_env_setup} rake db:seed")

        if FixturesFromFactories.configuration.factory_bot_definition_file_paths
          FactoryBot.definition_file_paths = FixturesFromFactories.configuration.factory_bot_definition_file_paths
        end
        FactoryBot.reload

        # Prepare the fixture files
        FixtureGenerator.new(output_path).generate do
          generator_index_klass.new(self, faker_seed, options).generate
        end

        # After fixtures are build the Rails env set in the DB is lost, so set it manually
        system("#{database_env_setup} bin/rails db:environment:set RAILS_ENV=development")

        ::Timecop.return
      end
    end
  end
end
