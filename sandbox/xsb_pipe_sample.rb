xsb = IO.popen("xsb", "w")

xsb.puts "true."
result = xsb.gets
xsb.puts "halt."


p "The Result was #{result}."




