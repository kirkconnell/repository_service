require File.join(File.dirname(__FILE__), "../spec_helper.rb")

class TestTranslationHelper
    include RepositoryService::TranslationHelper
end

module RepositoryService  
  
  describe TranslationHelper do

    before(:all) do
      @pk = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD6gkiTvzHRJQviUXnlK4aO2U7j
M14MU3fyKvom7yTRrjq5cwVgtIEZb6ZFTX6wM4y4ii3r1qjoyuIKQwYV0heHswe6
jmoAmGJyTNY1dtrshcXN6N3Co5zXCShmQdt/y3bUDl9/rrVHatAAwDhC9/RwecjG
pV24BPuAEjIJfa1gVwIDAQAB" 
    end

    it "should generate context name for a public key" do
      th = TestTranslationHelper.new
      th.context_name(@pk).should == "rsa_b2fcee5a72a0f5674d6537e870d71543" 
    end

    it "should translate a single atom clause to an imported single atom clause" do
      th = TestTranslationHelper.new
      clause_node = Controller.parse_credentials(CRED_MSG).certs.first[:clauses][2]
      th.translate_clause(@pk, clause_node).should == "says(rsa_b2fcee5a72a0f5674d6537e870d71543, allow(jeremiah, read, file1)).".delete(" ")
    end

    it "should translate an implication clause to an imported implication clause" do
      th = TestTranslationHelper.new
      clause_node = Controller.parse_credentials(CRED_MSG).certs.first[:clauses][0]
      th.translate_clause(@pk, clause_node).should == "says(rsa_b2fcee5a72a0f5674d6537e870d71543, allow(PK, Access, Resources)) :- says(rsa_b2fcee5a72a0f5674d6537e870d71543, pk_bind(P, PK)), says(rsa_b2fcee5a72a0f5674d6537e870d71543, allow(P, Access, Resources)).".delete(" ")
    end   

  end
end
