# frozen_string_literal: true

require_relative "fixtures_from_factories/version"

module FixturesFromFactories
  class << self
    attr_reader :configuration

    def configure
      @configuration ||= Configuration.new
      yield(configuration) if block_given?
      configuration
    end
  end

  # Configuration class for initializer
  class Configuration
    # @dynamic devise_password_hash
    attr_accessor :devise_password_hash, :excluded_tables

    def initialize
      @devise_password_hash = "$2a$11$M8e7PEPxv4JEx2JHLw4XnuvfVVafJjFb6DfMnODxSUy5WhIgfbF1y" # 'password' TODO: make this not use the hashed value but let it be hashed at creation time
      @excluded_tables = %w[schema_migrations spatial_ref_sys ar_internal_metadata]
    end
  end
end
