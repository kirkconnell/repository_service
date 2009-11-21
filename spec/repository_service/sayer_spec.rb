require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module RepositoryService
  class TestSayer
    include Sayer
  end
    
  describe Sayer do

    before(:each) do
      @sayer = TestSayer.new
    end

    def sayer
      @sayer
    end

    it "should have a silent mode option" do
      sayer.be_quiet!
      sayer.should be_quiet
    end
  
    it "should be not be quiet by default" do
      sayer.should_not be_quiet
    end    
  end
end
