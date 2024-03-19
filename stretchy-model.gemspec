# frozen_string_literal: true

require_relative "lib/stretchy/version"

Gem::Specification.new do |spec|
  spec.name = "stretchy-model"
  spec.version = Stretchy::VERSION
  spec.authors = ["Spencer Markowski"]
  spec.email = ["spencer.markowski@theablefew.com"]

  spec.summary = "Rails ORM for Elasticsearch"
  spec.description = "Provides a familiar ActiveRecord-like interface for working with Elasticsearch"
  spec.homepage = "https://github.com/theablefew/stretchy"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/theablefew/stretchy"
  spec.metadata["changelog_uri"] = "https://github.com/theablefew/stretchy/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "stretchy-model/lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_dependency "zeitwerk", "~> 2.4"
  spec.add_dependency "elasticsearch-rails", "~> 7.1"
  spec.add_dependency "elasticsearch-persistence", "~> 7.1"
  spec.add_dependency "elasticsearch-model", "~> 7.1"
  spec.add_dependency "rainbow", "~> 3.0"
  spec.add_dependency "amazing_print", "~> 1.3"
  spec.add_dependency "jbuilder", "~> 2.11"
  spec.add_dependency "virtus", "~> 2.0"

  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "simplecov", "~> 0.21.2"
  spec.add_development_dependency "opensearch-ruby", "~> 3.0"
  spec.add_development_dependency "rdoc-markdown", "~> 0.4.2"
  spec.add_development_dependency "octokit", "~> 4.20"
  spec.add_development_dependency "versionomy", "~> 0.5.0"
  spec.add_development_dependency "faker", "~> 2.18"
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
