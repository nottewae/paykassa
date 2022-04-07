# frozen_string_literal: true

require_relative "lib/paykassa/version"

Gem::Specification.new do |spec|
  spec.name = "paykassa"
  spec.version = Paykassa::VERSION
  spec.authors = ["nottewae"]
  spec.email = ["nottewae@gmail.com"]

  spec.summary = "Library for PayKassa Service"
  spec.description = "Library for PayKassa Service. Send and recieve payments."
  spec.homepage = "http://github.com/nottewae/paykassa"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.3"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://github.com/nottewae/paykassa"
  spec.metadata["changelog_uri"] = "http://github.com/nottewae/paykassa/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "redcarpet", "~> 2.3.0"
  spec.add_development_dependency "yard", "~> 0.9.27"
  spec.add_development_dependency "rspec-core", "~> 3.11.0"
  spec.add_development_dependency "rspec-expectations", "~> 3.11.0"
  spec.add_development_dependency "rr", "~> 3.0.3"
  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
