require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module RepositoryService
  describe Controller do
    
    it "should have a parser" do
      Controller.parser.should_not be_nil
    end
    
    it "should parse credentials" do
      node = Controller.parse_credentials(CRED_MSG)
      node.public_key.should_not be_blank
    end
    
    it "should parse challenge responses" do
      node = Controller.parse_response(RESP_MSG)
      node.m.should_not be_blank
    end
    
    it "should parse repository requests" do
      node = Controller.parse_request(REQ_MSG)
      node.request.should_not be_blank
    end
    
    it "should authenticate responses" do
      original = "f373066732b54c9e8433158624963900"
      signature = "oVluvLQtEcVmkLqsYWMVEuUNfan8OrbLWYX/SrDaaPRWuEiy6b821hmkCyGLn49c
EUl5V2VFHU+hghio/ULDbYYFqIxgl2AjhV4HlkPiGKantNL6zjbQTB+uB5MRtMhV
U0fWXVfIAEiHWZKOZaHidu27bdWCAhx7dL3iXx4nXIY=
"
      pk = "-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCvC+m32GusrDvN5tQyAlr7SEcg
cyNTfLSHG14bgX2CQzz6z5saoYGZWI3blurN4M+yTLlYEQGcI5bqqoFy40V7b2UF
+UtU7hlXF+0041qDgN6iQGca19mizpBsdHycYgR4NaXcEt1P3JNOczX9HDTqdXSP
1wECQ1TmlDRLCFoqSwIDAQAB
-----END PUBLIC KEY-----"
      
      Controller.authenticate(signature, original, pk).should == true
    end
    
  end
end