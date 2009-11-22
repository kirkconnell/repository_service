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

    def authorization
      result = ask_xsb
      puts result
      if result === /.+yes.+/
        "granted"
      else
        "denied"
      end
    end

    ###################################################

    def session_filename
      challenge = client.challenge      
      "session_#{challenge}.P"
    end

    def create_session_policy_file
      File.open(session_filename, "w+") do |file|
        add_local_policy_to file
        add_content_to file
      end
    end

    def add_local_policy_to(file)
      file << "/* Local Policy */\n"
      file << File.read("./policies/local.P")
      file
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

    def translate_request(request)
      context = context_name(client.public_key)
      request.sub( /request\(/, "allow(#{context}, ") + "."
    end

    def ask_xsb
      `echo halt. | xsb -e "[session_#{client.challenge}],#{translate_request client.latest_request}"`
    end
    
  end
end
