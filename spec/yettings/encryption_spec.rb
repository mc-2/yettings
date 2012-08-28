require 'spec_helper'

describe Yettings::Encryption do
  YETTINGS_DIR = "#{Rails.root}/config/yettings"
  YETTING_FILE = "#{Rails.root}/config/yetting.yml"
  BLANK_YETTING_FILE = "#{Rails.root}/config/yettings/blank.yml"

  let(:default_yml){ File.read "#{YETTINGS_DIR}/defaults.yml" }
  let(:blank_yml){ "" }

  subject { Yettings }

  describe ".decrypt_yml" do
    it "decrypts yml" do
      subject.decrypt_yml(default_yml)
    end
  end

  describe ".encrypt_yml" do
    it "encrypts yaml" do
      p subject.encrypt(default_yml)
    end
  end

  describe ".decrypt_hash" do
    pending
  end

  describe ".encrypt_hash" do
    pending
  end

  describe ".decrypt" do
    pending
  end

  describe ".encrypt" do
    pending
  end

  describe ".decrypt_string" do
    pending
  end

  describe ".encrypt_string" do
    pending
  end

  describe ".encrypt_file" do
    pending
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
