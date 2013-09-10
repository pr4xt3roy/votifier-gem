# Votifier Gem (Alpha Version)

Ruby Gem for a Votifier Server and Client for Minecraft

This version is missing a lot of feature.

## Installation

For a manual installation, type this on your console:

    $ gem install votifier

## Usage

    require 'votifier'
    server = Votifier::MinecraftServer.new(public_key_file, "some.minecraft-server.com")
    votifier = Votifier::Client.new("MyMinecraftServerList.info", server)
    votifier.send(:username => "Notch")

If you have the player's IP addess and the timestamp, you can pass them

    require 'votifier'
    server = Votifier::MinecraftServer.new(public_key_file, "some.minecraft-server.com:9999")
    votifier = Votifier::Client.new("MyMinecraftServerList.info", server)
    votifier.send(:username => "Notch", :ip_address => @ip_address, :timestamp => @timestamp)

The MinecraftServer can receive the hostname/port in different ways:

    Votifier::MinecraftServer.new(public_key_file) => defaults to "localhost:8192"
    Votifier::MinecraftServer.new(public_key_file, "some.minecraft-server.com") => port 8192
    Votifier::MinecraftServer.new(public_key_file, 9999)  => defaults to "localhost"
    Votifier::MinecraftServer.new(public_key_file, "some.minecraft-server.com:9999")
    Votifier::MinecraftServer.new(public_key_file, "some.minecraft-server.com", 9999)
    Votifier::MinecraftServer.new(public_key_file, 999, "some.minecraft-server.com")
    server = Votifier::MinecraftServer.new(public_key_file)
    server.host = "some.minecraft-server.com:9999"

For the server:

    require 'votifier'
    Votifier::Server.new(private_key_file, '0.0.0.0:8193').listen

## TODO

* Unit Tests
* Adding Observer so custom class can perform tasks when a vote is received.
* Adding RDocs or Yard documentation
* Change the Server's constructor to accept hostname and port directly
* Add new class MinecraftPlayer (username, ip_address)
* Server should use start instead of listen

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
