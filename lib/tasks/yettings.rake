namespace :yettings do
  desc "generate public/private key pair for encrypting sensitive yetting files"
  task :gen_keys => :environment do
    Yettings.gen_keys
  end

  desc "encrypt sensitive yetting files for checking into revision control"
  task :encrypt => :environment do
    Yettings.encrypt_files!
  end

  desc "decrypt sensitive yetting files for editing"
  task :decrypt => :environment do
    Yettings.decrypt_files!
  end
end

