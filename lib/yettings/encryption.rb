module Yettings
  module Encryption
    extend ActiveSupport::Concern

    KEY_SIZE = 3072
    DELIMITER = "========"

    # Set the maximum amount of data the RSA key can encrypt
    MAX_BYTES = KEY_SIZE / 8 - 11

    module ClassMethods
      def decrypt_string(public_string)
        if private_key_exists?
          public_string.split(DELIMITER).map { |s| s.decrypt(:asymmetric) }.join
        else
          "access denied (no private key found)"
        end
      end

      def encrypt_string(private_string)
        (0..private_string.length/MAX_BYTES).map do |i|
          first = i * MAX_BYTES
          last = (i + 1) * MAX_BYTES - 1
          private_string[first..last].encrypt(:asymmetric)
        end.join(DELIMITER)
      end

      def encrypt_file(private_file)
        # Don't overwrite encrypted file without key
        return unless private_key_exists?

        public_file = public_path(private_file)
        public_yml = encrypt_string File.read(private_file)
        return unless check_overwrite(public_file, private_file, public_yml)
        File.open(public_file, 'w') { |f| f.write public_yml }
      end

      def encrypt_files!
        find_private_yml_files.each do |yml_file|
          encrypt_file yml_file
        end
      end

      def decrypt_file(public_file)
        private_file = private_path(public_file)
        private_yml = decrypt_string File.read(public_file)
        return unless check_overwrite(private_file, public_file, private_yml)
        File.open(private_file, 'w') { |f| f.write private_yml }
      end

      def decrypt_files!
        find_public_yml_files.each do |yml_file|
          decrypt_file yml_file
        end
      end

      def private_path(path)
        path.gsub(/^#{root}/, "#{private_root}").gsub(/.pub$/, "")
      end

      def public_path(path)
        path.gsub(/^#{private_root}/, root) + '.pub'
      end

      def check_overwrite(dest, source, content)
        unless File.exists?(dest)
          warn "WARNING: creating #{dest} with contents of #{source}"
          FileUtils.mkpath File.dirname(dest)
          return true
        end
        return false if File.read(dest) == content
        if File.mtime(source) > File.mtime(dest)
          warn "WARNING: overwriting #{dest} with contents of #{source}"
          true
        else
          false
        end
      end

      def private_key_exists?
        File.exists? key_path(:private)
      end

      def key_path(type)
        ENV["YETTINGS_#{type.to_s.upcase}_KEY"] || "#{root}/.#{type}_key"
      end

      def gen_keys
        key = OpenSSL::PKey::RSA.new KEY_SIZE

        private_path = "#{root}/.private"
        FileUtils.mkpath private_path

        private_file = "#{root}/.private_key"
        File.open(private_file, 'w') { |f| f.write key.to_pem }

        public_file = "#{root}/.public_key"
        File.open(public_file, 'w') { |f| f.write key.public_key.to_pem }

        gitignore = "#{root}/.gitignore"
        File.open(gitignore, 'a') do |f|
          f.puts ".private_key"
          f.puts ".private"
        end
      end
    end
  end
end
