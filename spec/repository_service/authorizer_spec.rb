require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module RepositoryService
  describe Authorizer do
    before(:each) do
      @auth = Authorizer.new
      @controller = Controller.new
      @controller.be_quiet!
    end

    def controller
      @controller
    end
    
    it "should receive a list of certificate nodes and extract the clauses" do
      cert_nodes = controller.parse_credentials(CRED_MSG).certs
      @auth.load_certificates cert_nodes
      @auth.certificate_clauses.length.should == 1
    end
    
    it "should translate the clauses of the certificate nodes" do
      cert_nodes = controller.parse_credentials(CRED_MSG).certs
      @auth.load_certificates cert_nodes
      
      @auth.translated_clauses_for(cert_nodes.first[:pk]).length.should == 5
    end
    
  end
end
