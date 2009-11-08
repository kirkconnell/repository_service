require 'repository_service/socket_reader'
require 'repository_service/controller'

module RepositoryService
  class Client
    include SocketReader
    attr_accessor :cert
    attr_accessor :public_key
    attr_reader   :latest_request
  
    def initialize(sock)
      @sock = sock
      self.line_finishers = [ "-----END MPKI CREDENTIAL-----\n",
                              "-----END MPKI CHALLENGE RESPONSE-----\n", 
                              "-----END REPOSITORY CLIENT REQUEST-----\n" ]
    end
  
    def credentials(server)
      raw_data = receive_message
      node = Controller.parse_credentials(raw_data)
      self.cert = node.cert
      self.public_key = node.pk
    end
  
    def responds(server)
      raw_data = receive_message
      node = Controller.parse_response(raw_data)
      signature = node.m
      original = server.challenge
    
      Controller.authenticate signature, original, self.public_key
      print "Signature Verification Succeded.\n"
    end
  
    def requests(server)
      raw_data = receive_message
      node = Controller.parse_request(raw_data)
      @latest_request = node.request
      
      #todo: crazy boy authorization
    end
  
    def finished?
      !wait_for_next_message
    end
  end
end