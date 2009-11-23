require 'repository_service/socket_reader'
require 'repository_service/controller'

module RepositoryService
  class Client
    include SocketReader
    attr_accessor :certs # [ {}, {}, {}]
    attr_accessor :public_key
    attr_accessor :challenge
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
      original = self.challenge
    
      controller.authenticate :signature => signature, :signed_data => original, :pk => self.public_key
      server.client = self
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

    def invalid?(certificate)
      if certificate[:expiration_dates].nil?
        say "No validity limitation on certificate. Certificate is considered Permanent.\n"
        false
      else
        not_before, not_after = controller.convert_to_date(certificate[:expiration_dates])
        if DateTime.now < not_before
          say "Certificate is not valid until #{not_before}\n"
          true
        elsif DateTime.now > not_after
          say "Certificate is not valid after #{not_after}\n"
          true
        else
          false
        end
      end
    end


  private
    def keep_valid_certs(node)
      node.certs.each do |cert|
        if controller.authenticate(cert) && !invalid?(cert)
          self.certs << cert 
        else
          say "Invalid certicate received. Ignoring its content.\n"
        end
      end
    end
  end
end
