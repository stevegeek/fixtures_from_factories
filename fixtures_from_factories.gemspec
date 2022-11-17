# frozen_string_literal: true

require_relative "lib/fixtures_from_factories/version"

Gem::Specification.new do |spec|
  spec.name = "fixtures_from_factories"
  spec.version = FixturesFromFactories::VERSION
  spec.authors = ["Stephen Ierodiaconou"]
  spec.email = ["stevegeek@gmail.com"]

  spec.summary = "Build a set of Fixtures for your Rails app, using your test suite's FactoryBot factories. "
  spec.description = "A tool to help build a set of Fixtures for your Rails app, using your test suite's FactoryBot factories. ."
  spec.homepage = "https://github.com/stevegeek/fixtures_from_factories"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rails", ">= 6"
  spec.add_dependency "factory_bot"
  spec.add_dependency "faker"
  spec.add_dependency "devise"
  spec.add_dependency "timecop"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
