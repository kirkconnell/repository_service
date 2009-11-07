require File.join(File.dirname(__FILE__), "../spec_helper.rb")

CRED_MSG = File.read(File.join(File.dirname(__FILE__), "messages/cred.msg"))

module RepositoryService
  describe Controller do
    
    before(:all) do
      RepositoryService.load_grammar
    end
    
    it "should have a parser" do
      Controller.parser.should_not be_nil
    end
    
    it "should parse credentials" do
      node = Controller.parse_credentials(CRED_MSG)
      node.public_key.should_not be_blank
    end
    
    # it "should parse challenge responses" do
    #   fail
    # end
    
  end
end