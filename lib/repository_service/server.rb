require 'repository_service/socket_reader'
require 'repository_service/controller'
require 'repository_service/authorizer'
require 'repository_service/sayer'
require 'uuidtools'

module RepositoryService
  class Server
    include Sayer
    attr_reader :authorizer
  
    def initialize(sock)
      @sock = sock
      @authorizer = RepositoryService::Authorizer.new
    end
  
    def challenges(client)
      client.challenge = UUIDTools::UUID.random_create.to_s.delete '-'
      say "Sending Challenge #{client.challenge}\n"
      challenge_message = "-----BEGIN MPKI CHALLENGE-----\n#{client.challenge}\n-----END MPKI CHALLENGE-----\n"
      @sock.send(challenge_message, 0)
    end
  
    def replies(client)
      result = authorizer.authorize_request_from(client)
      reply = "-----BEGIN REPOSITORY SERVER REPLY-----\n#{result}-----END REPOSITORY SERVER REPLY-----\n"
      @sock.send(reply, 0)
    end
  
  end
end
