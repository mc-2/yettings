$:.push File.expand_path("../lib", __FILE__)

require "yettings/version"

Gem::Specification.new do |s|
  s.name        = "yettings"
  s.version     = Yettings::VERSION
  s.authors     = ["mc-2"]
  s.email       = ["john.mcaliley@gmail.com"]
  s.summary     = "encrypted YAML settings/constants for your rails app"
  s.description = "Yettings uses encrypted YML files that allow you to safely store sensitive configuration data such as API keys and passwords in your repository.  Yettings makes these key/values available by creating a class and instance methods.  Ex: Yetting.some_setting"

  s.files = Dir["{lib}/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "growl"
  s.add_development_dependency "spork"
  s.add_development_dependency "simplecov"
end
