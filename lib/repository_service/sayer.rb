module RepositoryService
  module Sayer
    def say(words)
      print words unless @silent_mode
    end
    
    def be_quiet!
      @silent_mode = true
    end
    
    def quiet?
      @silent_mode
    end
  end
end
