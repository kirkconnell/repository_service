require 'repository_service/socket_reader'
require 'repository_service/controller'
require 'uuidtools'

module RepositoryService
  class Server
    attr_accessor :challenge
  
    def initialize(sock)
      @sock = sock
    end
  
    def challenges(client)
      self.challenge = UUIDTools::UUID.random_create.to_s.delete '-'
      print "Sending Challenge #{self.challenge}\n"
      challenge_message = "-----BEGIN MPKI CHALLENGE-----\n#{self.challenge}\n-----END MPKI CHALLENGE-----"
      @sock.send(challenge_message, 0)
    end
  
    def replies(client)
    
    end
  
  end
end