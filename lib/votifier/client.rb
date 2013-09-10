require 'socket'      # Sockets are in standard library

module Votifier
  class Client

    attr_reader :socket_object, :service_name
    attr_accessor :minecraft_server

    def initialize(service_name, minecraft_server, opts = {})
      @service_name = service_name
      @minecraft_server = minecraft_server
      @socket_object = opts.fetch(:socket_object, TCPSocket)
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

    def send opts = {}
      validate!(opts)
      votifier_string = to_unencrypted_packet_array(opts).join("\n")
      encrypted = minecraft_server.encrypt(votifier_string)
      send_to_server(encrypted)
    end

    def validate!(opts)
      raise 'Usename must be between 2 and 16 characters' unless !opts.key?(:username) || (opts[:username].size >= 2 && opts[:username].size <= 16)
    end

    def send_to_server(encrypted)
      s = open_server
      s.print encrypted
      s.close
    end

    def open_server
      socket_object.open(minecraft_server.hostname, minecraft_server.port)
    end

    def to_unencrypted_packet_array(opts)
      [
        "VOTE",
        service_name,
        opts.fetch(:username, ""),
        opts.fetch(:ip_address, detect_ip_address),
        opts.fetch(:timestamp, Time.now.to_i)
      ]
    end

  end
end
