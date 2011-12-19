require 'cora'
require 'siri_objects'
require 'uri'
require 'net/http'

#######
# Remember to add other plugins to the "config.yml" file if you create them!
######

class SiriProxy::Plugin::MeaningOfLife < SiriProxy::Plugin
  attr_accessor :phrase_file
  
  def initialize(config = {})

    if config["phrase_file"].nil?
      x = ""
    else
      x = config["phrase_file"]
    end
    
    if File.exist? x
      self.phrase_file = x
    else
      self.phrase_file = File.dirname(File.dirname(__FILE__))+"/mol.txt"
    end
  #  ::MeaningOfLife.configure do |config|
  #    config.phrase_file = @config['phrase_file'] 
  #  end
    
  end

  listen_for /a joke/i do
    url = "http://jokes.tfound.org/jokebot/?format=text"
    r = Net::HTTP.get_reponse( URI.parse( url ) )
    if r.code == 200
      say r.body
    else
      say "Jokes? Jokes? Who needs stinking Jokes?"
    end
    request_completed
  end
  
  listen_for /meaning of life/i do
    lines = IO.readlines(self.phrase_file)
    rl = rand(lines.count-1)
    say lines[rl]
    request_completed
  end  

end
