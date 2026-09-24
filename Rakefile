# frozen_string_literal: true

require "bundler/gem_tasks"

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

desc "Run tests"
task :test do
  sh "bin/test"
end

require "standard/rake"

task default: %i[test standard]
