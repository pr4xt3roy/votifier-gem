require 'socket'      # Sockets are in standard library

module Votifier
  class Client

    attr_reader :public_key, :service_name
    attr_accessor :username, :ip_address, :timestamp

    def initialize(public_key_file, service_name, opts = {})
      init_public_key(public_key_file)
      @service_name = service_name
      @username = opts.fetch(:username, nil)
      @ip_address = opts.fetch(:ip_address, detect_ip_address)
      @timestamp = opts.fetch(:timestamp, Time.now.to_i)
    end

    def init_public_key(public_key_file)
      @public_key = Votifer::Key.from_public_key_file(public_key_file)
    end

    def detect_ip_address
      remote_ip = ENV['HTTP_X_FORWARDED_FOR'] || ENV['REMOTE_ADDR'] || my_best_ip_address
      remote_ip = remote_ip.ip_address if remote_ip.respond_to?(:ip_address)
      remote_ip = remote_ip.scan(/[\d.]+/).first
    end

    def my_best_ip_address
      my_first_public_ipv4 || my_first_private_ipv4
    end

    def my_first_public_ipv4
      ips.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}
    end

    def my_first_private_ipv4
      ips.detect{|intf| intf.ipv4_private?}
    end

    def ips
      @ips ||= Socket.ip_address_list
    end

    def send
      validate!
      votifier_string = to_a.join("\n")
      encrypted = encrypt(votifier_string)
      send_to_server(encrypted)
    end

    def validate!
      raise 'Usename must be present' unless !username.nil?
    end

    def encrypt(votifier_string)
      encrypted = public_key.public_encrypt(votifier_string)
      raise "Error encrypting, invalid size: #{encrypted.bytesize}" unless encrypted.bytesize == 256
      encrypted
    end

    def send_to_server(encrypted)
      hostname = 'localhost'
      port = 8193

      s = TCPSocket.open(hostname, port)

      s.print encrypted
      s.close
    end

    def to_a
      [
       "VOTE",
       service_name,
       username,
       ip_address,
       timestamp
      ]
    end

  end
end
