module RepositoryService
  module SocketReader
    def receive_message
      data = @sock.recvfrom(50.kilobytes)
      unless dos_attack? data
        message = data.first
        print "Message Received:\n#{message}\n"
        message
      else
        raise "Message exceeds 50K limit. Connection closed."
      end
    end

    def dos_attack?(data)
      if data.first.length > (50.kilobytes)
        @sock.shutdown 
        true
      else
        false
      end
    end
  end
end