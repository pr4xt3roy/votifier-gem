require 'spec_helper'
describe Votifier::Server do

  context "default parameters" do
    before do
      @private_key_file = File.expand_path('../../../config/sample-private.key', __FILE__)
      @server = Votifier::Server.new(@private_key_file)
    end

    context "#open_tcp_server" do

      before do
        @tcp_server = @server.open_tcp_server
      end

      it "should not be closed" do
        @tcp_server.closed?.should eq false
      end
    end

  end

end

