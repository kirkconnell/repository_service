spec_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.expand_path(File.join(spec_dir, "../lib"))

$:.unshift(lib_dir)
$:.uniq!

require 'rubygems'
require 'spec/autorun'
require 'repository_service'

IMP_CRED_MSG = File.read(File.join(File.dirname(__FILE__), "repository_service/messages/cred_with_imports.msg"))
CRED_MSG = File.read(File.join(File.dirname(__FILE__), "repository_service/messages/cred.msg"))
RESP_MSG = File.read(File.join(File.dirname(__FILE__), "repository_service/messages/resp.msg"))
REQ_MSG = File.read(File.join(File.dirname(__FILE__), "repository_service/messages/req.msg"))
CRED_NO_VAL_MSG = File.read(File.join(File.dirname(__FILE__), "repository_service/messages/cred_no_exp.msg"))

RepositoryService.load_grammar
