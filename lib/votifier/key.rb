require 'forwardable'
require 'openssl'
module Votifier
  class Key

    # Create a new key from a PEM formated string
    # @param [String] pem_key_content The PEM formated string
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
        self.from_unknown_key_content(key.read)
      elsif key.match('pub.*\.key$')
        self.from_key_file(key, :public)
      elsif key.match('priv.*\.key$')
        self.from_key_file(key, :private)
      elsif key.match('.*\.pem$')
        self.from_pem_key_file(key)
      elsif key.respond_to?(:to_s)
        self.from_unknown_key_content(key.to_s)
      else
        raise 'Invalid key file format. Support formats: public.key, private.key, key.pem or string.'
      end
    end

    # Import a key from a string or array and detect what format and type the key is.
    # @param [Array,String] key_content The key content as a string (or array of lines)
    # @return [Votifier::Key] The key that was imported.
    def self.from_unknown_key_content(key_content)
      if key_content.is_a?(Array)
        if key_content[0].match(/\n/)
          key_content = key_content.join("")
        else
          key_content = key_content.join("\n")
        end
      end
      if key_content.match(/^\-\-\-\-\-BEGIN /)
        self.from_pem_key_content(key_content)
      else
        if key_content.bytesize > 1000
          self.from_key_content(key_content, :private)
        else
          self.from_key_content(key_content, :public)
        end
      end
    end

    # Import a non-PEM key from a filename
    # @param [String] key_file The filename of the key without the PEM headers.
    # @param [Symbol] type The type of key, Either :public or :private. Defaults to :private
    # @return [Votifier::Key] The imported key
    def self.from_key_file(key_file, type = :private)
      key_content = File.read(key_file)
      self.from_key_content(key_content, type)
    end

    # Import a non-PEM key from a String
    # @param [String] key_content The actual key content in a non-PEM format.
    # @param [Symbol] type The type of key, Either :public or :private. Defaults to :private
    # @return [Votifier::Key] The imported key
    def self.from_key_content(key_content, type = :private)
      pem_key_content = self.convert_to_pem_format(key_content, type)
      self.from_pem_key_content(pem_key_content)
    end

    # Import a PEM key from a filename
    # @param [String] key_file The filename of the PEM key
    # @return [Votifier::Key] The imported key
    def self.from_pem_key_file(key_file)
      key_content = File.read(key_file)
      self.from_pem_key_content(key_content)
    end

    # Import a PEM key from a string
    # @param [String] key_content The actual key content in a PEM format.
    # @return [Votifier::Key] The imported key
    def self.from_pem_key_content(pem_key_content)
      self.new(pem_key_content)
    end

    # Convert a non-PEM key string into a PEM key format string
    # @param [String] key_content The string of the non-PEM key
    # @param [Symbol] type The type of key, Either :public or :private.
    # @return [String] The key in a PEM format
    def self.convert_to_pem_format(key_content, type)
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
