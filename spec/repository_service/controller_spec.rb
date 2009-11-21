require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module RepositoryService
  describe Controller do

    before(:all) do
      @controller = Controller.new
      @controller.be_quiet!
    end

    def controller
      @controller
    end    

    describe "parsing messages" do
      it "should have a parser" do
        controller.parser.should_not be_nil
      end
      
      describe "credentials" do
        before(:all) do
          @node = controller.parse_credentials(CRED_MSG)
        end
      
        it "should parse credentials" do
          @node.public_key.should_not be_blank
        end
      
        it "should extract certificates from credentials" do
          @node.certificates.should_not be_empty
        end
        
        it "should be easy to extract certificate information" do
          cert = @node.certs.first
          cert[:clauses].should_not be_blank
          cert[:signed_data].should == "allow(PK,Access,Resources):-pk_bind(P,PK),allow(P,Access,Resources).pk_bind(jeremiah,rsa_3fcb4a57240d9287e43b8615e9994bba).allow(jeremiah,read,file1).allow(jeremiah,_anyAccess,file2).allow(jeremiah,read,file3).datime(2007,10,12,0,0,0).datime(2007,12,19,0,0,0)."
          cert[:pk].should_not be_blank
          cert[:signature].should_not be_blank
        end
        
      end
    
      it "should parse challenge responses" do
        node = controller.parse_response(RESP_MSG)
        node.m.should_not be_blank
      end
    
      it "should parse repository requests" do
        node = controller.parse_request(REQ_MSG)
        node.request.should_not be_blank
      end
      
    end
    
    describe "authenticating" do
      
      it "should authenticate credential certificates" do
        cert = {
          :signed_data => "allow(PK,Access,Resources):-pk_bind(P,PK),allow(P,Access,Resources).pk_bind(jeremiah,rsa_3fcb4a57240d9287e43b8615e9994bba).allow(jeremiah,read,file1).allow(jeremiah,_anyAccess,file2).allow(jeremiah,read,file3).datime(2007,10,12,0,0,0).datime(2007,12,19,0,0,0).",
          :pk => "-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD6gkiTvzHRJQviUXnlK4aO2U7j
M14MU3fyKvom7yTRrjq5cwVgtIEZb6ZFTX6wM4y4ii3r1qjoyuIKQwYV0heHswe6
jmoAmGJyTNY1dtrshcXN6N3Co5zXCShmQdt/y3bUDl9/rrVHatAAwDhC9/RwecjG
pV24BPuAEjIJfa1gVwIDAQAB
-----END PUBLIC KEY-----",
          :signature => "oL3P17UlIEi24hwu69vS+NIxB+XZKPhEbdZ0RUWt5iMm3VLDRFUFTbdeWzTgdAT8
qRlennVsbIHBLEjO5zj+It5ggEIqu9HR6j9aQGHkcET3Dg9wh2/qqOHGs4ULtsex
UlN8fQQxt3aWieJgi/ZEkMhLErz9lZ6io6X8icWh0oM="
        }
        controller.authenticate(cert).should == true
      end
    
      it "should authenticate challenge responses" do
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
      
        controller.authenticate(:signature => signature, :signed_data => original, :pk => pk).should == true
      end
      
    end
  end
end
