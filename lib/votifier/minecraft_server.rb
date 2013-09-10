module Votifier
  class MinecraftServer

    DEFAULT_HOSTNAME = 'localhost'
    DEFAULT_PORT     = 8192

    IP_REGEXP = Regexp.new('\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b')
    HOSTNAME_REGEXP = Regexp.new('\b(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])\b')
    IP_OR_HOSTNAME_REGEXP = Regexp.new('^(' + IP_REGEXP.to_s + '|' + HOSTNAME_REGEXP.to_s + ')$')
    IP_OR_HOSTNAME_WITH_PORT_REGEXP = Regexp.new('^(' + IP_REGEXP.to_s + '|' + HOSTNAME_REGEXP.to_s + '):\d+$')

    attr_accessor :hostname, :port, :public_key
    attr_reader :key

    def initialize(key, *args)
      raise 'The key parameter is required' unless !key.nil? && key != ""
      init_key(key)
      raise 'Votifier::MinecraftServer#new accept 1 to 3 parameters only.' unless args.size <= 2
      self.send(:host=, *args)
    end

    def init_key(key)
      @key = Votifier::Key.import(key)
    end

    def host=(*args)
      args.each do |arg|
        if arg.is_a?(Fixnum) || arg == arg.to_s.to_i.to_s
          @port = arg.to_i
        elsif arg.respond_to?(:to_s) && arg.to_s.match(IP_OR_HOSTNAME_REGEXP)
          @hostname = arg.to_s
        elsif arg.respond_to?(:to_s) && arg.to_s.match(IP_OR_HOSTNAME_WITH_PORT_REGEXP)
          @hostname, @port = arg.split(':')
          @port = @port.to_i
        else
          raise "Unexpected value: #{arg.inspect}"
        end
      end
      if @hostname.nil? || @hostname == ""
        @hostname = default_hostname
      end
      if @port.nil? || @port == ""
        @port = default_port
      end
    end

    def encrypt(votifier_string)
      encrypted = key.public_encrypt(votifier_string)
      raise "Error encrypting, invalid size: #{encrypted.bytesize}" unless encrypted.bytesize == 256
      encrypted
    end

    def private_decrypt(encrypted)
      key.private_decrypt(encrypted)
    end

    def default_hostname
      DEFAULT_HOSTNAME
    end

    def default_port
      DEFAULT_PORT
    end

  end
end
