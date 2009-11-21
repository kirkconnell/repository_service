require 'thread_storage'
require 'openssl'
require 'base64'
require 'digest/md5'

module RepositoryService
  class Controller
    include ThreadStorage
    include Sayer
  
    def parser
      storage[:parser]
    end
  
    def parse_credentials(raw_message)
      parse_message raw_message, "credential", "Parsing Credentials"
    end
  
    def parse_response(raw_message)
      parse_message raw_message, "response", "Parsing Challenge Response"
    end
    
    def parse_request(raw_message)
      parse_message raw_message, "request", "Parsing Repository Request"
    end
    
    def authenticate(cred)
      authenticate_signature cred[:signature], cred[:signed_data], cred[:pk]
    end

    def authenticate_signature(signature, original, pk)
      key = OpenSSL::PKey::RSA.new(pk)
      raise "Invalid Signature to Challenge Message." unless 
        key.verify(OpenSSL::Digest::MD5.new, Base64.decode64(signature), original)
      true
    end

private
    def parse_message(raw_message, message_type,  notification='')
      say "#{notification}\n" unless notification.blank?
      tree = parser.parse(raw_message)
      if tree
        raise "#{message_type.titleize} Message Expected" unless tree.message_type == message_type
        tree
      else
        raise "Invalid #{message_type.titleize} Format: #{parser.failure_reason}"
      end
    end
  end
end
