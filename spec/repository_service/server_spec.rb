require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module RepositoryService
  describe Server do
    
    def sock(stub={})
      @sock ||= mock("socket", stub.merge(:send => true))
    end
    
    def server
      @server ||= Server.new(sock)
    end
    
    def client
      @client ||= mock("client")
    end
    
    it "challenges client" do
      server.challenges client
      server.challenge.should_not be_nil
    end
    
    it "replies to client" do
      server.replies client
    end
    
  end
end