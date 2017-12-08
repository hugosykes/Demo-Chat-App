require 'sinatra/base'

module WhisperModule
  class Whisper < Sinatra::Base
    get '/' do
      erb :'index.html'
    end
  end
end