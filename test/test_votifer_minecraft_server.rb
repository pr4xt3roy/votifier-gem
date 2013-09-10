require 'test/unit'
require 'votifier'

class VotifierMinecraftServerTest < Test::Unit::TestCase

  def setup
    @public_key = File.expand_path('../../config/sample-public.pem', __FILE__)
    @private_key = File.expand_path('../../config/sample-private.pem', __FILE__)
  end

  def test_public_key_works
    server = Votifier::MinecraftServer.new(@public_key)
    assert_not_equal "", server.encrypt("random_string_to_encode")
  end

  def test_private_key_works
    server = Votifier::MinecraftServer.new(@private_key)
    assert_not_equal "", server.encrypt("random_string_to_encode")
  end

  def test_ip_with_port_in_one_string
    server = Votifier::MinecraftServer.new(@private_key, '1.1.1.1:99')
    assert_equal '1.1.1.1', server.hostname
    assert_equal 99, server.port
  end

  def test_ip_with_port_separate
    server = Votifier::MinecraftServer.new(@private_key, '1.1.1.1', 99)
    assert_equal '1.1.1.1', server.hostname
    assert_equal 99, server.port
  end

  def test_hostname_with_port_separate
    server = Votifier::MinecraftServer.new(@private_key, 'some.minecraft-server.com', 99)
    assert_equal 'some.minecraft-server.com', server.hostname
    assert_equal 99, server.port
  end

  def test_opposite_order
    server = Votifier::MinecraftServer.new(@private_key, 99, 'some.minecraft-server.com')
    assert_equal 'some.minecraft-server.com', server.hostname
    assert_equal 99, server.port
  end

  def test_port_can_be_a_string_too
    server = Votifier::MinecraftServer.new(@private_key, 'some.minecraft-server.com', '99')
    assert_equal 'some.minecraft-server.com', server.hostname
    assert_equal 99, server.port
  end

  def test_using_host
    server = Votifier::MinecraftServer.new(@private_key)
    server.host = '1.1.1.1:99'
    assert_equal '1.1.1.1', server.hostname
    assert_equal 99, server.port
  end

end
