require 'socket'               # Get sockets from stdlib
module Votifier
  class Server

    attr_reader :minecraft_server
    attr_writer :tcp_server_class, :thread_class

    def initialize(*args)
      if args.size == 1 && args[0].respond_to?(:hostname) && args[0].respond_to?(:port) && args[0].respond_to?(:private_decrypt)
        @minecraft_server = args[0]
      elsif args.size == 1 && (args[0].respond_to?(:to_s) || args[0].respond_to?(:private_decrypt))
        @minecraft_server = Votifier::MinecraftServer.new(args[0])
      elsif args.size == 2
        @minecraft_server = Votifier::MinecraftServer.new(args[0], args[1])
      elsif args.size == 3
        @minecraft_server = Votifier::MinecraftServer.new(args[0], args[1], args[2])
      else
        raise "Invalid parameters : #{args.inspect}"
      end
      @tcp_server_class = TCPServer
      @thread_class = Thread
    end

    def listen
      server = open_tcp_server
      loop {                         # Servers run forever
        @thread_class.start(server.accept) do |client| # Wait for a client to connect
          handle_connection(client)
        end
      }
    end

    def open_tcp_server
      # Socket to listen on interface/port
      @tcp_server_class.open(minecraft_server.hostname, minecraft_server.port)
    end

    def handle_connection(client)
      lines = ""
      while line = client.gets
        lines += line
      end
      begin
        vote_info = parse_content(lines)
        vote = Vote.from_array(vote_info)
        puts vote.to_h
        client.close                 # Disconnect from the client
      rescue => e
        puts e.inspect
        puts e.backtrace
      end
    end

    def parse_content(content)
      raise Error::InvalidVotePacket, "Must be 256 bytes: is #{content.bytesize}" unless content.bytesize == 256
      vote_info_string = decrypt(content)
      raise Error::InvalidVotePacket, 'Must contains newline characters' unless vote_info_string.match(/\n/)
      vote_info = vote_info_string.split("\n")
      raise Error::InvalidVotePacket, 'Must contain 5 elements or more' unless vote_info.size >= 5
      raise Error::InvalidVotePacket, 'Invalid opcode: must be VOTE' unless vote_info[0] == "VOTE"
      vote_info
    end

    def decrypt(encrypted_string)
      string = minecraft_server.private_decrypt(encrypted_string)
      string
    end

    class Error
      class InvalidVotePacket < StandardError
        def initialize(str)
          super("Invalid Vote Packet: #{str}")
        end
      end
    end
  end
end
