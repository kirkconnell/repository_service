require "rubygems"
require "net/ssh"

klass = Net::SSH::KeyFactory.get("rsa")

k = Net::SSH::KeyFactory.load_private_key("client.rsa.der")
#key = File.read("client.rsa.der")
#OpenSSL::PKey::RSA.new(key)