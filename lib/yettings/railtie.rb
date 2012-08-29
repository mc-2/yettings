require 'rails'
require 'encrypted_strings'
require 'yettings'

module Yettings
  class Railtie < Rails::Railtie
    config.before_configuration do
      Yettings.setup!
    end
    rake_tasks do
      load File.expand_path('../../tasks/yettings.rake', __FILE__)
    end
  end
end

