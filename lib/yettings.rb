require 'yaml'
require 'erb'
require 'openssl'
require "yettings/railtie.rb"
require "yettings/base.rb"
require "yettings/encryption.rb"

module Yettings
  include Yettings::Encryption

  class UndefinedYettingError < StandardError; end
  class NameConflictError < StandardError; end

  class << self
    def setup!
      EncryptedStrings::SymmetricCipher.default_algorithm = 'DES-EDE3-CBC'
      find_yml_files.each do |yml_file|
        create_yetting_class yml_file
      end
    end

    def create_yetting_class(yml_file)
      name = klass_name(yml_file)
      klass = Object.const_set(name, Class.new(Yettings::Base))
      klass.load_yml_erb yaml_erb(yml_file)
    end

    def yaml_erb(yml_file)
      yaml_erb = File.read(yml_file)
      yaml_erb = decrypt_string(yaml_erb) if pub?(yml_file)
      yaml_erb
    end

    def pub?(yml_file)
      yml_file.end_with? ".pub"
    end

    def klass_name(yml_file)
      basename = File.basename(yml_file)
      if basename == "yetting.yml"
        name = "Yetting"
      else
        name = basename.gsub(/\.pub$/,"").gsub(/\.yml$/,"").camelize + "Yetting"
      end
      return name unless Object.const_defined?(name)
      if name.constantize.ancestors.include? Yettings::Base
        Object.module_eval { remove_const name }
        return name
      else
        raise NameConflictError, "#{name} is already defined"
      end
    end

    def rails_config
      "#{Rails.root}/config"
    end

    def root
      "#{rails_config}/yettings"
    end

    def private_root
      "#{root}/\.private"
    end

    def find_yml_files
      Dir.glob("#{rails_config}/yetting.yml") + Dir.glob("#{root}/**/*.yml") + Dir.glob("#{root}/**/*.yml.pub")
    end

    def find_public_yml_files
      Dir.glob("#{root}/**/*.yml.pub")
    end

    def find_private_yml_files
      Dir.glob("#{private_root}/**/*.yml")
    end
  end # class << self
end

