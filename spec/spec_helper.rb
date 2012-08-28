require 'spork'

Spork.prefork do
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path('../dummy/config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'factory_girl'
  require "shoulda-matchers"

  Dir[Rails.root.join("../spec/support/**/*.rb")].each {|f| require f }

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true
    config.filter_run_excluding :external => true
    config.infer_base_class_for_anonymous_controllers = false
  end
end

Spork.each_run do
  FactoryGirl.reload
end
