require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module RepositoryService
  describe Server do
    
    def sock(stub={})
      @sock ||= mock("socket", stub.merge(:send => true))
    end
    
    def server
      @server ||= Server.new(sock, "./policies/local.P")
    end
    
    def client
      @client ||= mock("client", :latest_request => "request", :challenge= => "abcdefghijklmnop", :challenge => "abcdefghijklmnop", :certs => [])
    end

    before(:all) do
      server.be_quiet!
    end
    
    it "challenges client" do
      client.should_receive(:challenge=).once
      server.challenges client
    end
    
    it "replies to client" do
      server.stub!(:authorizer).and_return(mock("authorizer", :authorization => "granted"))
      server.replies client
    end
    
    it "should authorize request for replying" do
      server.stub!(:authorizer).and_return(mock("authorizer", :authorization => "granted"))
      server.authorizer.should_receive(:authorization)
      server.replies client
    end

    it "should set the client to the authorizer" do
      server.client = client
      server.authorizer.client.should == client
    end

    it "should load the client certificates when setting the client to the authorizer" do
      server.authorizer.should_receive(:load_certificates)      
      server.client = client
    end
    
  end
end
