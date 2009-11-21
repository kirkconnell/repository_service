require 'repository_service/socket_reader'
require 'repository_service/controller'

module RepositoryService
  class Client
    include SocketReader
    attr_accessor :certs # [ {}, {}, {}]
    attr_accessor :public_key
    attr_reader   :latest_request
    attr_reader   :controller
  
    def initialize(sock)
      @sock = sock
      @line_finishers = [ "-----END MPKI CREDENTIAL-----\n",
                          "-----END MPKI CHALLENGE RESPONSE-----\n", 
                          "-----END REPOSITORY CLIENT REQUEST-----\n" ]
      @certs = []
      @controller = Controller.new
    end

    def be_quiet!
      controller.be_quiet!      
      super      
    end
  
    def credentials(server)
      raw_data = receive_message
      node = controller.parse_credentials(raw_data)
      self.public_key = node.pk
      keep_valid_certs(node)
    end
  
    def responds(server)
      raw_data = receive_message
      node = controller.parse_response(raw_data)
      signature = node.m
      original = server.challenge
    
      controller.authenticate :signature => signature, :signed_data => original, :pk => self.public_key
      say "Signature Verification Succeded.\n"
    end
  
    def requests(server)
      raw_data = receive_message
      node = controller.parse_request(raw_data)
      @latest_request = node.request
    end
  
    def finished?
      !wait_for_next_message
    end
  private
    def keep_valid_certs(node)
      node.certs.each { |cert| self.certs << cert if controller.authenticate(cert) }
    end
  end
end
