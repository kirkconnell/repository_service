require 'rubygems'
require 'activesupport'
require 'socket'
require 'treetop'
require 'polyglot'
require 'grammar/repository_protocol'

require 'repository_service/server'
require 'repository_service/client'
require 'thread_storage'

require 'repository_service/translation_helper'

module RepositoryService
  extend ThreadStorage
  
  def self.start
    if ARGV[0] == "-h"
      print "Usage: ./server.rb PORT POLICY_FILE_PATH\n"
      Process.exit
    end

    port = ARGV[0]
    port ||= 5432

    @@policy_file = ARGV[1]
    @@policy_file ||= "./policies/local.P"

    TCPServer.new(port)
  end

  def self.policy_file
    @@policy_file
  end
  
  def self.load_grammar
    storage[:parser] = RepositoryProtocolParser.new
  end
  
end
