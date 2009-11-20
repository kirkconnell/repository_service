require 'repository_service/translation_helper'

module RepositoryService
  class Authorizer
    include TranslationHelper
    attr_reader :certificate_clauses
    
    def initialize
      @certificate_clauses = []
    end
    
    def load_certificates(cert_nodes)
      cert_nodes.each { |e| @certificate_clauses << {:clauses => e[:clauses], :pk => e[:pk]} }
      certificate_clauses.each do |cert|
        cert[:translated] = []
        cert[:clauses].each { |clause| cert[:translated] << translate_clause(cert[:pk], clause) }
      end
    end
    
    def translated_clauses_for(pk)
      searched_cert = @certificate_clauses.select { |cert| cert[:pk] == pk }
      searched_cert.first[:translated]
    end
    
    def authorize_request(request)
      "granted"
    end
  
    
  end
end