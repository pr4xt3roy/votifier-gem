module Votifier
  class Vote
    attr_reader :service_name, :username, :ip_address, :timestamp

    def initialize(service_name, username, ip_address, timestamp)
      @service_name = service_name
      @username = username
      @ip_address = ip_address
      @timestamp = timestamp
    end

    def self.from_array(vote_info)
      opcode, service_name, username, ip_address, timestamp, empty_space = vote_info
      vote = Vote.new(service_name, username, ip_address, timestamp)
      vote
    end

    def to_h
      {
        :service_name => service_name,
        :username => username,
        :ip_address => ip_address,
        :timestamp => timestamp
      }
    end
  end
end
