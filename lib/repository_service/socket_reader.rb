require 'repository_service/sayer'

module RepositoryService
  module SocketReader
    include Sayer
    attr_accessor :line_finishers
    
    def receive_message
      message = read_complete_message
      unless dos_attack? message
        say "Message Received:\n#{message}\n"
        message
      else
        raise "Message exceeds 50K limit. Connection closed."
      end
    end

    def dos_attack?(data)
      if data.length > (50.kilobytes)
        @sock.shutdown 
        true
      else
        false
      end
    end
    
    def wait_for_next_message
      results = select([@sock], nil, nil)
      if results[0].include? @sock
        say "Incoming!\n"
        true
      else
        say "I don't know where that came from sir!\n"
        false
      end
    end
    
    def read_complete_message
      message = ""
      last_line = ""
      begin
        last_line = @sock.readline
        message << last_line
      end until @line_finishers.include? last_line
      message
    end
  end
end
