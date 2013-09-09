# Votifier Gem (Alpha Version)

Ruby Gem for a Votifier Server and Client for Minecraft

This version is missing a lot of feature.

## Installation

For a manual installation, type this on your console:

    $ gem install votifier

## Usage

    require 'votifier'
    votifier = Votifier::Client.new(public_key_file, "MyMinecraftServerList.info", :hostname => "some.minecraft-server.com")
    votifier.send(:username => "Notch")

If you have the player's IP addess and the timestamp, you can pass them

    require 'votifier'
    votifier = Votifier::Client.new(public_key_file, "MyMinecraftServerList.info")
    votifier.hostname = "some.minecraft-server.com"
    votifier.port = 9999   # if the server uses a non-standard port 8192
    votifier.send(:username => "Notch", :ip_address => @ip_address, :timestamp => @timestamp)

For the server:

    require 'votifier'
    Votifier::Server.new(:private_key => private_key_file).listen

## TODO

* Unit Tests
* Adding Observer so custom class can perform tasks when a vote is received.
* Adding RDocs or Yard documentation
* Add interface to bind to and port as part of Vortifier::Server constructor
* Add new class MinecraftServer (hostname, port, key)
* Add new class MinecraftPlayer (username, ip_address)
* Server should use start instead of listen

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
