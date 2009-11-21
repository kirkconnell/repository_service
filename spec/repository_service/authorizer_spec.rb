require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module RepositoryService
  describe Authorizer do

    before(:all) do
      @controller = Controller.new
      @controller.be_quiet!
      @cert_nodes = @controller.parse_credentials(CRED_MSG).certs
    end

    before(:each) do
      @auth = Authorizer.new
      @auth.client = mock("client", :latest_request => "request", :challenge => "I CAN HAZ CHEEZEBURGER")
    end

    def cert_nodes
      @cert_nodes
    end
    
    it "should receive a list of certificate nodes and extract the clauses" do
      @auth.load_certificates cert_nodes
      @auth.certificate_clauses.length.should == 1
    end
    
    it "should translate the clauses of the certificate nodes" do
      @auth.should_receive(:translate_clause).exactly(5).times
      @auth.should_receive(:add_content_to)
      @auth.load_certificates cert_nodes
      
      @auth.translated_clauses_for(cert_nodes.first[:pk]).length.should == 5
    end

    it "should create a policy file named as the challenge string" do
      challenge = "I CAN HAZ CHEEZEBURGER"
      @auth.should_receive(:create_session_policy_file).once
      @auth.load_certificates cert_nodes
    end

    it "should create a policy file containing all the clauses of all the certificates" do
      @auth.load_certificates cert_nodes
      @auth.add_content_to("").should_not be_blank
    end
    
  end
end
