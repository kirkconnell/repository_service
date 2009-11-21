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
      @client ||= mock("client", :latest_request => "request", :challenge= => "", :challenge => "")
    end

    before(:all) do
      server.be_quiet!
    end
    
    it "challenges client" do
      client.should_receive(:challenge=).once
      server.challenges client
    end
    
    it "replies to client" do
      server.stub!(:authorizer).and_return(mock("authorizer", :authorize_request_from => "granted"))
      server.replies client
    end
    
    it "should authorize request for replying" do
      server.stub!(:authorizer).and_return(mock("authorizer", :authorize_request_from => "granted"))
      server.authorizer.should_receive(:authorize_request_from)
      server.replies client
    end
    
  end
end
