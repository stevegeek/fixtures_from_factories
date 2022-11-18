# frozen_string_literal: true

module FixturesFromFactories
  class BaseBuilder
    def initialize(generator, rand_seed, options)
      @generator = generator
      @rand_seed = rand_seed
      @options = options
    end

    attr_reader :generator, :options

    def generate
      raise NotImplementedError
    end
  end
end
