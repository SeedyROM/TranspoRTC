require "./messages"
require "json"

class TranspoRTC::Server
    alias Connections = Set(HTTP::WebSocket)
    getter :host, :port

    private def on_socket_open(context, socket)
        socket.on_message do |message|
            begin
                json = JSON.parse(message)
                handle_message(context, socket, json.as_h)
            rescue ex
                socket.send({:error => "invalid command"}.to_json)
                puts ex.message
            end
        end

        socket.on_close do |message|
            @@open_connections.delete(socket)
        end

        @@open_connections << socket
    end

    private def handler_chain
        [
            HTTP::ErrorHandler.new,
            HTTP::LogHandler.new,
            HTTP::WebSocketHandler.new {|socket, context| on_socket_open(context, socket)}
        ]
    end

    @@open_connections : Connections = Connections.new

    def initialize(@host = "0.0.0.0", @port = 8080)
    end

    def server
        @@server ||= HTTP::Server.new(@host, @port, handler_chain)
    end

    def listen
        server.listen
    end

    def handle_message(context, socket, data)
        # TODOS:
        # HERE WE GO!
        if data.has_key?("action")
            socket.send(data.to_json)
        end
    end
end