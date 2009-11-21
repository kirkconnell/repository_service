require 'repository_service/translation_helper'

module RepositoryService
  class Authorizer
    include TranslationHelper
    attr_reader :certificate_clauses
    attr_accessor :client
    
    def initialize
      @certificate_clauses = []
    end
    
    def load_certificates(cert_nodes)
      cert_nodes.each { |e| @certificate_clauses << {:clauses => e[:clauses], :pk => e[:pk]} }
      certificate_clauses.each do |cert|
        cert[:translated] = []
        cert[:clauses].each { |clause| cert[:translated] << translate_clause(cert[:pk], clause) }
      end
      create_session_policy_file
    end

    def create_session_policy_file
      File.open("./policies/#{client.challenge}.P", "w+") do |file|
        add_content_to file
      end
    end

    def add_content_to(file)
      certificate_clauses.each do |cert|
        file << "/* Clauses for Context #{context_name(cert[:pk])} */\n"
        cert[:translated].each { |clause| file << clause << "\n\n" }
      end
      file
    end
    
    def translated_clauses_for(pk)
      searched_cert = @certificate_clauses.select { |cert| cert[:pk] == pk }
      searched_cert.first[:translated]
    end
    
    def authorize_request_from(client)
      @client = client
      "granted"
    end
  
    
  end
end
