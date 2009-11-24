require 'thread_storage'
require 'openssl'
require 'base64'
require 'digest/md5'
require 'repository_service/client_exception'

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

    def convert_to_date(validity_range)
      not_before = DateTime.new(validity_range[:not_before][:year],
                                validity_range[:not_before][:month],
                                validity_range[:not_before][:day],
                                validity_range[:not_before][:hour],
                                validity_range[:not_before][:minute],
                                validity_range[:not_before][:second])
      not_after  = DateTime.new(validity_range[:not_after][:year],
                                validity_range[:not_after][:month],
                                validity_range[:not_after][:day],
                                validity_range[:not_after][:hour],
                                validity_range[:not_after][:minute],
                                validity_range[:not_after][:second])
      [not_before, not_after]
    end
    
    def authenticate(cred)
      authenticate_signature cred[:signature], cred[:signed_data], cred[:pk]
    end

    def authenticate_signature(signature, original, pk)
      key = OpenSSL::PKey::RSA.new(pk)
      raise ClientException.new("Invalid Signature.") unless 
        key.verify(OpenSSL::Digest::MD5.new, Base64.decode64(signature), original)
      true
    end

private
    def parse_message(raw_message, message_type,  notification='')
      say "#{notification}\n" unless notification.blank?
      tree = parser.parse(raw_message)
      if tree
        raise ClientException.new("#{message_type.titleize} Message Expected") unless tree.message_type == message_type
        tree
      else
        raise ClientException.new("Invalid #{message_type.titleize} Format: #{parser.failure_reason}")
      end
    end
  end
end
