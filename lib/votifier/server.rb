require 'socket'               # Get sockets from stdlib
module Votifier
  class Server

    attr_reader :private_key

    def initialize(opts)
      raise ':private_key options is required' unless opts.key?(:private_key)
      init_private_key(opts[:private_key])
    end

    def init_private_key(private_key_file)
      @private_key = Votifer::Key.from_key_file(private_key_file)
    end

    def listen
      server = TCPServer.open(8193)  # Socket to listen on port
      loop {                         # Servers run forever
        Thread.start(server.accept) do |client| # Wait for a client to connect
          handle_connection(client)
        end
      }
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
      string = private_key.private_decrypt(encrypted_string)
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
