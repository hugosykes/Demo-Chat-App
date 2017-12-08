require 'faye/websocket'
# require 'eventmachine'

module WhisperModule
  class WhisperBackend
    KEEPALIVE_TIME = 15

    def initialize(app)
      @app = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        # WebSockets logic goes here

        # @channel = EventMachine::Channel.new

        # Thread.new {
        #   EventMachine.run {
        #     @channel.subscribe { |url|
        #       ws = Faye::WebSocket::Client.new(url)
        #        def setup_socket(url)
        #          @channel.push(url)
        #        end
        #     }
        #   }
        # }


        # we set ping parameter to ping a packet every 15 seconds because
        # after 55 seconds of idleness, Heroku will terminate the connection
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})

        ws.on :open do |event|
          p "ws.object_id:", ws.object_id
          @clients << ws
        end

        ws.on :message do |event|
          p "event.data:", event.data
          @clients.each { |client| client.send(event.data) } # we broadcast the data (message) to each client
        end

        ws.on :close do |event|
          p [:close, ws.object_id, event.code, event.reason]
          @clients.delete(ws)
          ws = nil
        end

        # Return async Rack response
        ws.rack_response
      else
        @app.call(env)
      end
    end
  end
end