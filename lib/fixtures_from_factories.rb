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
    attr_accessor :devise_password_hash

    def initialize
      @devise_password_hash = "$2a$11$M8e7PEPxv4JEx2JHLw4XnuvfVVafJjFb6DfMnODxSUy5WhIgfbF1y" # 'password'
    end
  end
end
