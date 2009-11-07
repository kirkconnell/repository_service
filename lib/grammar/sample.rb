require "rubygems"
require "treetop"
require "polyglot"
require "repository_protocol"

m = File.read("cert.msg")

parser = RepositoryProtocolParser.new
cert_tree = parser.parse(m)
p cert_tree.message_type
p cert_tree.pk
p cert_tree.cert