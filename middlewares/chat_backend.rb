require 'faye/websocket'
require(File.expand_path('comms_operator.rb', File.dirname(__FILE__)))

module WhisperModule
  class WhisperBackend
    KEEPALIVE_TIME = 15

    def initialize(app)
      @comms_operator = CommsOperator.new
      @app = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)

        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_TIME)

        ws.on :open do |_event|
          p 'ws.object_id:', ws.object_id
          @clients << ws
        end

        ws.on :message do |event|
          p 'event.data:', event.data
          # @comms_operator.
          @clients.each { |client| client.send(event.data) }
        end

        ws.on :close do |event|
          p [:close, ws.object_id, event.code, event.reason]
          @clients.delete(ws)
          ws = nil
        end

        ws.rack_response
      else
        @app.call(env)
      end
    end
  end
end
