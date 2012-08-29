require 'spec_helper'

describe Yettings::Encryption do
  YETTINGS_DIR = "#{Rails.root}/config/yettings"
  YETTING_FILE = "#{Rails.root}/config/yetting.yml"
  SECRET_YETTING_FILE = "#{Rails.root}/config/yettings/.private/secret2.yml"
  SECRET_YETTING_PUB_FILE = "#{Rails.root}/config/yettings/secret2.yml.pub"
  BLANK_YETTING_FILE = "#{Rails.root}/config/yettings/blank.yml"

  let(:default_yml){ File.read "#{YETTINGS_DIR}/defaults.yml" }
  let(:blank_yml){ "" }

  describe ".decrypt_string" do
    it "decrypts the string in binary" do
      str = "This is a private string"
      encrypted = Yettings.encrypt_string(str)
      Yettings.decrypt_string(encrypted).should eq str
    end
  end

  describe ".encrypt_string" do
    it "encrypts the string in binary" do
      str = "This is a private string"
      Yettings.encrypt_string(str).equals_without_encryption(str).should be false
      Yettings.encrypt_string(str).equals_with_encryption(str).should be true
    end
  end

  describe ".encrypt_file" do
    before(:each) do
      File.delete(SECRET_YETTING_PUB_FILE) if File.exists?(SECRET_YETTING_PUB_FILE)
    end

    after(:each) do
      File.delete(SECRET_YETTING_PUB_FILE) if File.exists?(SECRET_YETTING_PUB_FILE)
    end

    it "returns nil if the private key is nil" do
      Yettings.stub(:private_key => nil)
      Yettings.encrypt_file(YETTING_FILE).should eq nil
    end

    it "returns nil check_overwrite is false" do
      Yettings.stub(:check_overwrite => false)
      Yettings.encrypt_file(YETTING_FILE).should eq nil
    end

    it "writes to file if private key is available and check_overwrite passes" do
      Yettings.stub(:check_overwrite => true)
      Yettings.encrypt_file(SECRET_YETTING_FILE)
      File.exists?(SECRET_YETTING_PUB_FILE)
    end
  end

  describe ".decrypt_file" do
    pending
  end

  describe ".encrypt_files!" do
    pending
  end

  describe ".decrypt_files!" do
    pending
  end

  describe ".encrypt_files!" do
    pending
  end

  describe ".check_overwrite" do
    pending
  end

  describe ".private_path" do
    pending
  end

  describe ".public_path" do
    pending
  end

  describe ".public_key" do
    pending
  end

  describe ".private_key" do
    pending
  end

  describe ".load_key" do
    pending
  end

  describe ".key_path" do
    pending
  end

  describe ".gen_keys" do
    pending
  end

end
