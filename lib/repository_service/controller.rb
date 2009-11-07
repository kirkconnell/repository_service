require 'thread_storage'
require 'openssl'

module RepositoryService
  class Controller
    extend ThreadStorage
  
    def self.parser
      storage[:parser]
    end
  
    def self.parse_credentials(raw_message)
      parse_message raw_message, "credential", "Parsing Credentials"
    end
  
    def self.parse_response(raw_message)
      parse_message raw_message, "response", "Parsing Challenge Response"
    end
  
    def self.authenticate(signature, original, pk)
      header = "-----BEGIN RSA PUBLIC KEY-----"
      footer = "-----END RSA PUBLIC KEY-----"
      key = OpenSSL::PKey::RSA.new([header, pk, footer].join("\n"))
      raise "Invalid Signature to Challenge Message." unless key.verify(OpenSSL::Digest::MD5.new, signature, original)
    end
    
    def self.parse_message(raw_message, message_type,  notification='')
      print "#{notification}\n" unless notification.blank?
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