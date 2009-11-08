require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module RepositoryService
  describe Client do
    
    def sock
      @sock ||= mock("Socket")
    end
    
    def client
      @client ||= Client.new(sock)
    end
    
    def me
      @me ||= mock("Server", {:challenge => "O HAI!"})
    end
    
    describe "handing credentials" do
      
      before(:each) do
        client.stub!(:receive_message => CRED_MSG)
        client.certs.clear
      end
      
      it "should send credentials to me" do
        client.credentials me
      end

      it "should save public key for when I need it" do
        client.credentials me
        client.public_key.should == "-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCvC+m32GusrDvN5tQyAlr7SEcg
cyNTfLSHG14bgX2CQzz6z5saoYGZWI3blurN4M+yTLlYEQGcI5bqqoFy40V7b2UF
+UtU7hlXF+0041qDgN6iQGca19mizpBsdHycYgR4NaXcEt1P3JNOczX9HDTqdXSP
1wECQ1TmlDRLCFoqSwIDAQAB
-----END PUBLIC KEY-----

"      
      end

      it "should store authentic certificates" do
        Controller.stub!(:authenticate => true)
        client.credentials me
        client.certs.should_not be_empty
      end

      it "should not store nonauthentic certificates" do
        Controller.stub!(:authenticate => false)
        client.credentials me
        client.certs.should be_empty
      end 
    end
    
    it "should respond to my challenge" do
      client.stub!(:receive_message => RESP_MSG)
      Controller.stub!(:authenticate => true)
      client.responds me
    end
    
    it "should verify if socket isn't closed" do
      client.stub!(:wait_for_next_message => true)
      client.should_not be_finished
    end
    
    it "should parse requests" do
      client.stub!(:receive_message => REQ_MSG)
      client.requests me
      client.latest_request.should == "request(read, files)"
    end
    
  end
end