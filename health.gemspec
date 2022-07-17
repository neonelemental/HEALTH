require_relative "lib/health/version"

Gem::Specification.new do |spec|
  spec.name        = "health"
  spec.version     = Health::VERSION
  spec.authors     = ["mikekolich"]
  spec.email       = ["mike.kolich@upstart.com"]
  spec.homepage    = "https://github.com/upstart/health"
  spec.summary     = "Rails health check tooling."
  spec.license     = "MIT"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "clockwork", "~> 2.0"
  spec.add_dependency "rails", ">= 7.0.2.4"
  spec.add_development_dependency "rspec-rails", "~> 5.1"
  spec.add_development_dependency "shoulda-matchers", "~> 5.0"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "factory_bot_rails"
end
