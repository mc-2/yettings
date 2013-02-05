require 'spec_helper'

describe Yettings::Encryption do
  YETTINGS_DIR = "#{Rails.root}/config/yettings"
  YETTING_FILE = "#{Rails.root}/config/yetting.yml"
  SECRET_YETTING_FILE = "#{Rails.root}/config/yettings/.private/secret.yml"
  SECRET_YETTING_PUB_FILE = "#{Rails.root}/config/yettings/secret.yml.pub"
  BLANK_YETTING_FILE = "#{Rails.root}/config/yettings/blank.yml"

  let(:default_yml){ File.read "#{YETTINGS_DIR}/defaults.yml" }
  let(:blank_yml){ "" }
  let(:large_string) do
    n = Yettings::Encryption::KEY_SIZE * 10
    letters = ('a'..'z').to_a
    n.times.map { letters.sample }.join
  end

  describe ".decrypt_string" do
    it "decrypts the string in binary" do
      str = "This is a private string"
      encrypted = Yettings.encrypt_string(str)
      Yettings.decrypt_string(encrypted).should eq str
    end

    it "decrypts a large string" do
      encrypted = Yettings.encrypt_string(large_string)
      Yettings.decrypt_string(encrypted).should eq large_string
    end
  end

  describe ".encrypt_string" do
    it "encrypts the string in binary" do
      str = "This is a private string"
      Yettings.encrypt_string(str).should_not eq str
    end

    it "encrypts a large string" do
      str = large_string
      Yettings.encrypt_string(str).should_not eq str
    end
  end

  describe ".encrypt_file" do
    before(:each) do
      if File.exists?(SECRET_YETTING_PUB_FILE)
        @pubfile_contents = File.open(SECRET_YETTING_PUB_FILE).read
        File.delete(SECRET_YETTING_PUB_FILE)
      end
    end

    after(:each) do
      File.open(SECRET_YETTING_PUB_FILE, 'w').write(@pubfile_contents)
    end

    it "returns nil if the private key doesn't exist" do
      Yettings.stub(:private_key_exists? => false)
      Yettings.encrypt_file(YETTING_FILE).should eq nil
    end

    it "returns nil check_overwrite is false" do
      Yettings.stub(:check_overwrite => false)
      Yettings.encrypt_file(YETTING_FILE).should eq nil
    end

    it "writes to file if private key is available and check_overwrite passes" do
      Yettings.stub(:private_key_exists? => true)
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
