require(File.expand_path('app', File.dirname(__FILE__)))
require(File.expand_path('middlewares/chat_backend', File.dirname(__FILE__)))

use WhisperModule::WhisperBackend

run WhisperModule::Whisper