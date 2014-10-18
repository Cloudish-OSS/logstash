# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "uri"
require "rest_client"

# Use logstash to send your logs to Cloudish!
class LogStash::Outputs::Cloudish < LogStash::Outputs::Base
  config_name "Cloudish"
  milestone 2

    config :host, :validate => :string, :default => "https://api.cloudish.net/signal"
    config :key, :validate => :string, :required => true
    config :signalType, :validate => :string, :required => true
    config :tags, :validate => :string, :required => false

  public
  
  def register
	#do Nothing
  end

  public
  def receive(event)
    return unless output?(event)

    if event == LogStash::SHUTDOWN
      finished
      return
    end
	
    uri = @host + "/" + @key + "/" + @signalType + "/" + @tags
    res = RestClient.post uri, event["message"], :content_type => 'application/x-www-form-urlencoded'
    
    if res.code==200
      @logger.info("Event send to Cloudish OK!")
    else
      @logger.warn("HTTP error", :error => res.code)
    end
  end # def receive
end # class LogStash::Outputs::Cloudish
