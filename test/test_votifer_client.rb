require 'test/unit'
require 'votifier'
require 'minitest/mock'

class VotifierClientTest < Test::Unit::TestCase

  def setup
    @socket_mock = MiniTest::Mock.new
    @socket_mock.expect(:open, @socket_mock, ["localhost", 8192])
    @socket_mock.expect(:print, 256, [String])
    @socket_mock.expect(:close, nil)
    @public_key_file = File.expand_path('../../config/sample-public.key', __FILE__)
  end

  def test_votifier_client_default
    Votifier::Client.new(@public_key_file, "Testing", :socket_object => @socket_mock).send
    assert @socket_mock.verify
  end

  def test_votifier_client_username
    Votifier::Client.new(@public_key_file, "Testing", :socket_object => @socket_mock).send(:username => "Notch")
    assert @socket_mock.verify
  end

  def test_votifier_client_postpone_setting_hostname_port
    votifier = Votifier::Client.new(@public_key_file, "Testing", :socket_object => @socket_mock)
    votifier.hostname = "some.mincraft-server.com"
    votifier.port = 8192
    @socket_mock.expect(:open, @socket_mock, [votifier.hostname, votifier.port])
    votifier.send(:username => "Notch")
    assert @socket_mock.verify
  end

end
