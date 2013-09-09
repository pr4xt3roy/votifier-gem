# Votifier

Votifier Server and Client for Minecraft

## Installation

For a manual installation, type this on your console:

    $ gem install votifier

## Usage

    require 'votifier'
    Votifier::Client.new("MyMinecraftServerList.info", :username => "Notch").send

If you have the player's IP addess and the timestamp, you can pass them

    require 'votifier'
    Votifier::Client.new("MyMinecraftServerList.info", :username => "Notch", :ip_address => @ip_address, :timestamp => @timestamp).send

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
