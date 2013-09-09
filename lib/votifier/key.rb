require 'forwardable'
require 'openssl'
module Votifer
  class Key

    def initialize(pem_key_content)
      @key = OpenSSL::PKey::RSA.new(pem_key_content)
    end

    def self.from_pem_key_file(key_file)
      key_content = File.read(key_file)
      self.from_perm_key_content(key_content)
    end

    def self.from_public_key_file(key_file)
      self.from_key_file(key_file, :public)
    end

    def self.from_key_file(key_file, type = :private)
      key_content = File.read(key_file)
      self.from_key_content(key_content, type)
    end

    def self.from_key_content(key_content, type = :private)
      pem_key_content = convert_to_pem_format(key_content, type)
      from_pem_key_content(pem_key_content)
    end

    def self.from_pem_key_content(pem_key_content)
      key = self.new(pem_key_content)
      key
    end

    def self.convert_to_pem_format(key_content, type = :private)
      key_headers = {
        :private => "RSA PRIVATE",
        :public => "PUBLIC"
      }
      header = key_headers[type]
      wrapped_key_content = key_content.scan(/.{1,65}/).join("\n")
      pem_key_content = "-----BEGIN #{header} KEY-----\n" +
        wrapped_key_content + "\n" +
        "-----END #{header} KEY-----"
      pem_key_content
    end

    extend Forwardable
    def_delegators :@key, :private_decrypt, :public_encrypt

  end
end
