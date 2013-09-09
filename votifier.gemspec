# -*- encoding: utf-8 -*-
require File.expand_path('../lib/votifier/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'votifier'
  gem.summary       = %q{Votifier Server and Client for Minecraft}
  gem.description   = %q{This allows you to accept Votifier connections OR send them to a Minecraft Server.}
  gem.authors       = ["Pr4xt3roy"]
  gem.email         = %W(pr4xt3roy@capricatown.net)
  gem.homepage      = 'https://github.com/pr4xt3roy/votifier-gem'

  gem.files         = `git ls-files`.split($\)
  gem.license       = 'MIT'
  gem.require_paths = ["lib"]
  gem.required_ruby_version = '>= 1.9.1'

  gem.version       = Votifier::VERSION
  gem.date          = '2013-09-08'
end
