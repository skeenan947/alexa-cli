require 'json'
require 'rest-client'

req = {
  "session"=>
  {
    "sessionId"=>"SessionId.foo",
    "application"=>{
      "applicationId"=>"amzn1.ask.skill.bar"
    },
    "attributes"=>{},
    "user"=>{
      "userId"=>"amzn1.ask.account.foo"
    },
    "new"=>true
  }, 
  "request"=>{
    "type"=>"IntentRequest", 
    "requestId"=>"EdwRequestId.bar", 
    "locale"=>"en-US", 
    "timestamp"=>"2017-02-19T04:03:34Z", 
    "intent"=>{
      "name"=>"",
      "slots"=>{}
    }
  }, 
  "version"=>"1.0"
}

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: request.rb [-i IntentName] [-u URL] [-s slotname=value]"
  options[:intent] = 'TestIntent'
  options[:slots] = ''
  options[:url] = "https://skeenan.net/alexa/"

  opts.on("-i IntentName", "--intent IntentName", "IntentName") do |o|
    options[:intent] = o
  end
  opts.on("-u URL", "--url URL", "URL to hit") do |o|
    options[:url] = o
  end
  opts.on("-s slot=value", "--slot slot1=value1,slot2=value2", "Slot name & value") do |o|
    options[:slots] = o
  end
end.parse!

puts "Requested intent: #{options[:intent]}\n"
req['request']['intent']['name'] = options[:intent]
optslots = options[:slots].split(',')
optslots.each do |slot|
  (name,value) = slot.split('=')
  req['request']['intent']['slots'][name] = {
    'name' => name,
    'value' => value
  }
end

puts "sending intent: #{options[:intent]}"
puts "slots: #{req['request']['intent']['slots'].to_json}" if !req['request']['intent']['slots'].nil?
response = RestClient.post(options[:url], req.to_json, headers={content_type: :json, accept: :json})
js_response = JSON.parse(response)
puts js_response['response']['outputSpeech']['text']

