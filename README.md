# Votifier Gem

Ruby Gem for a Votifier Server and Client for Minecraft

## Installation

For a manual installation, type this on your console:

    $ gem install votifier

## Usage

    require 'votifier'
    Votifier::Client.new(public_key_file, "MyMinecraftServerList.info", :username => "Notch").send

If you have the player's IP addess and the timestamp, you can pass them

    require 'votifier'
    Votifier::Client.new(public_key_file, "MyMinecraftServerList.info", :username => "Notch", :ip_address => @ip_address, :timestamp => @timestamp).send

For the server:

    require 'votifier'
    Votifier::Server.new(:private_key => private_key_file).listen

## TODO

* Unit Tests
* Support .pem, .key keys or string keys.
* The username, ip and timestamp should be passed to Votifier::Client#send instead of the contructor
* Adding Observer so custom class can perform tasks when a vote is received.
* Adding RDocs or Yard documentation
* Add hostname/port as part of the Votifier::Client constructor
* Add interface to bind to and port as part of Vortifier::Server constructor

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
