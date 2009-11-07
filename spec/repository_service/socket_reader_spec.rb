require File.join(File.dirname(__FILE__), "../spec_helper.rb")

class TestSocketReader
  include RepositoryService::SocketReader
  attr_accessor :sock
end

describe RepositoryService::SocketReader do
  
  before(:all) do
    @reader = TestSocketReader.new
    @reader.sock = mock("socket", {:recvfrom => ["O HAI, I CAN HAZ CHEEZEBURGER?"], :shutdown => true,})
  end
  
  def reader
    @reader
  end
  
  
  it "should receive messages" do
    reader.receive_message.should == "O HAI, I CAN HAZ CHEEZEBURGER?"
  end
  
  it "should allow messages smaller then 50K" do
    data = ""
    50.kilobytes.times { data << "A" }
    reader.should_not be_dos_attack([data])
  end
  
  it "should deny messages larger then 50K" do
    data = ""
    (50.kilobytes + 1).times { data << "A" }
    reader.should be_dos_attack([data])
  end
  
  it "should shutdown DOS attacks" do
    data = ""
    (50.kilobytes + 1).times { data << "A" }
    reader.sock.should_receive(:shutdown)
    reader.dos_attack?([data])
  end
  
end