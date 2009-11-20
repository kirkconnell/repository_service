require File.join(File.dirname(__FILE__), "../spec_helper.rb")

class TestSocketReader
  include RepositoryService::SocketReader
  attr_accessor :sock
  
  def initialize
    self.line_finishers = []
  end
end

describe RepositoryService::SocketReader do
  
  before(:each) do
    test_line = "O HAI! I CAN HAZ CHEEZEBURGER?\n"
    @reader = TestSocketReader.new
    @reader.line_finishers << test_line 
    @reader.sock = mock("socket", {:readline => test_line, :shutdown => true, :recv => ""})
  end
  
  def reader
    @reader
  end
  
  
  it "should receive multiline messages as one" do
    reader.receive_message.should == "O HAI! I CAN HAZ CHEEZEBURGER?\n"
  end
  
  it "should allow messages smaller then 50K" do
    data = ""
    50.kilobytes.times { data << "A" }
    reader.should_not be_dos_attack(data)
  end
  
  it "should deny messages larger then 50K" do
    data = ""
    (50.kilobytes + 1).times { data << "A" }
    reader.should be_dos_attack(data)
  end
  
  it "should shutdown DOS attacks" do
    data = ""
    (50.kilobytes + 1).times { data << "A" }
    reader.sock.should_receive(:shutdown)
    reader.dos_attack?(data)
  end
  
  it "should wait for more messages" do
    reader.should_receive(:select).and_return([[reader.sock]])
    reader.wait_for_next_message
  end
  
  it "should have a silent mode option" do
    reader.be_quiet!
    reader.should be_quiet
  end
  
  it "should be not be quiet by default" do
    reader.should_not be_quiet
  end
  
end