require 'spec_helper'

describe Yettings do
  YETTINGS_DIR = "#{Rails.root}/config/yettings"
  YETTING_FILE = "#{Rails.root}/config/yetting.yml"
  IGNORED_YETTING_FILE = "#{Rails.root}/config/ignored.yml"
  BLANK_YETTING_FILE = "#{Rails.root}/config/yettings/blank.yml"

  it "should load yettings in the rails app" do
    assert defined?(Yettings)
  end

  describe ".setup!" do
    it "sets setup public yettings classes" do
      Yettings.setup!
      assert defined?(BlankYetting)
      assert defined?(JimiYetting)
      assert defined?(HendrixYetting)
      assert defined?(DefaultsYetting)
    end

    it "sets up private yetting classes" do
      Yettings.setup!
      assert defined?(SecretYetting)
    end
  end

  describe ".create_yetting_class" do
    it "creates a yetting class from a file" do
      Yettings.create_yetting_class(IGNORED_YETTING_FILE)
      assert defined?(IgnoredYetting)
    end
  end

  describe ".klass_name" do
    it "should return Yetting if file is base yetting" do
      Yettings.klass_name(YETTING_FILE).should eq "Yetting"
    end

    it "should return SomeYetting" do
      Yettings.klass_name("#{YETTINGS_DIR}/some.yml").should eq "SomeYetting"
    end

    it "should raise an error if the class is already defined" do
      AlreadyDefinedConstantYetting = Class.new
      expect { Yettings.klass_name 'already_defined_constant.yml' }.
        to raise_error Yettings::NameConflictError
    end

    it "should not raise an error if the class is a descendant of Base" do
      AnotherAlreadyDefinedConstantYetting = Class.new Yettings::Base
      expect { Yettings.klass_name 'another_already_defined_constant.yml' }.
        to_not raise_error
    end
  end

  describe ".find_yml_files" do
    it "finds only main yml file if no others exist" do
      FileUtils.mv(YETTINGS_DIR,"#{YETTINGS_DIR}_tmp")
      begin
        Yettings.find_yml_files.should eq ["#{Rails.root}/config/yetting.yml"]
      ensure
        FileUtils.mv("#{YETTINGS_DIR}_tmp",YETTINGS_DIR)
      end
    end

    it "finds main and 3 yettings dir files" do
      Yettings.find_yml_files.should eq ["#{Rails.root}/config/yetting.yml",
                                         "#{YETTINGS_DIR}/blank.yml",
                                         "#{YETTINGS_DIR}/defaults.yml",
                                         "#{YETTINGS_DIR}/hendrix.yml",
                                         "#{YETTINGS_DIR}/jimi.yml",
                                         "#{YETTINGS_DIR}/secret.yml.pub"]
    end

    it "finds 3 yettings dir files if there is no main file" do
      FileUtils.mv("#{YETTING_FILE}","#{YETTING_FILE}_tmp")
      begin
        yml_files = Yettings.find_yml_files
        yml_files.should eq ["#{YETTINGS_DIR}/blank.yml",
                             "#{YETTINGS_DIR}/defaults.yml",
                             "#{YETTINGS_DIR}/hendrix.yml",
                             "#{YETTINGS_DIR}/jimi.yml",
                             "#{YETTINGS_DIR}/secret.yml.pub"]
      ensure
        FileUtils.mv("#{YETTING_FILE}_tmp","#{YETTING_FILE}")
      end
    end
  end
end
