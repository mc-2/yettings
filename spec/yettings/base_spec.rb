require 'spec_helper'

describe Yettings::Base do
  YETTINGS_DIR = "#{Rails.root}/config/yettings"
  YETTING_FILE = "#{Rails.root}/config/yetting.yml"
  BLANK_YETTING_FILE = "#{Rails.root}/config/yettings/blank.yml"

  subject { Class.new Yettings::Base }

  describe ".load_yml_erb" do

    it "should load the yml and return hash" do
      yml_erb = File.read YETTING_FILE
      expected = {"yetting1" => "what",
                  "yetting2" => 999,
                  "yetting3" => "this is erb",
                  "yetting4" => ["element1", "element2"]}
      subject.load_yml_erb(yml_erb).should eq expected
    end

    it "should apply default settings to all environments" do
      yml_erb = File.read "#{YETTINGS_DIR}/defaults.yml"
      subject.load_yml_erb(yml_erb)
      subject.yetting1.should eq 'default value'
    end

    it "should override default settings specific to environment" do
      yml_erb = File.read "#{YETTINGS_DIR}/defaults.yml"
      subject.load_yml_erb(yml_erb)
      subject.yetting2.should eq 'test value'
    end
  end

  describe ".method_missing" do
    it "should issue a warning for method_missing" do
      begin
        subject.whatwhat
      rescue => e
        e.should be_kind_of Yettings::Base::UndefinedYettingError
        e.message.should =~ /whatwhat is not defined in /
      end
    end
  end

  describe ".define_methods" do
    it "defines methods for a hash" do
      hash = {:method1 => "val1", :method2 => "val2"}
      subject.define_methods(hash)
      subject.method1.should eq "val1"
      subject.method2.should eq "val2"
    end
  end

  describe ".build_hash" do
    it "returns blank hash for empty yml file" do
      expected = {}
      subject.build_hash("").should eq expected
    end

    it "returns hash for non-blank yaml file" do
      yml = File.read "#{YETTINGS_DIR}/defaults.yml"
      expected = {"defaults"=>{"yetting1"=>"default value", "yetting2"=>"default value"}, "test"=>{"yetting2"=>"test value"}}
      subject.build_hash(yml).should eq expected
    end
  end
end
