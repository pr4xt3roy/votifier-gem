require 'forwardable'
require 'openssl'
module Votifier
  class Key

    def initialize(pem_key_content)
      @key = OpenSSL::PKey::RSA.new(pem_key_content)
    end

    # Import a RSA key from a filename, a File objetc or a string containing the key.
    #
    # Example Usage:
    #  key = Voritifer::Key.import(file_name)
    #
    # @param  [Mixed] key An RSA private or public key as a filename, a File object or a String.
    #   The format can be PEM (with the -- BEGIN headers) or plaim
    # @returns [Voritifer::Key] The object representing the key
    def self.import(key)
      if key.respond_to?(:read)
        self.from_pem_key_content(key.read)
      elsif key.match('pub.*\.key$')
        self.from_key_file(key, :public)
      elsif key.match('priv.*\.key$')
        self.from_key_file(key, :private)
      elsif key.match('.*\.pem$')
        self.from_pem_key_file(key)
      elsif key.respond_to?(:to_s)
        self.from_pem_key_content(key.to_s)
      else
        raise 'Invalid key file format. Support formats: public.key, private.key, key.pem or string.'
      end
    end

    def self.from_key_file(key_file, type = :private)
      key_content = File.read(key_file)
      self.from_key_content(key_content, type)
    end

    def self.from_key_content(key_content, type = :private)
      pem_key_content = self.convert_to_pem_format(key_content, type)
      self.from_pem_key_content(pem_key_content)
    end

    def self.from_pem_key_file(key_file)
      key_content = File.read(key_file)
      self.from_pem_key_content(key_content)
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
