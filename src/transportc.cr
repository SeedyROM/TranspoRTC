require "./transportc/*"
require "http/server"
require "colorize"

module TranspoRTC
   
end

server = TranspoRTC::Server.new
puts "Listening on #{server.host}:#{server.port}...".colorize(:green)
server.listen