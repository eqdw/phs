require 'sinatra'
require 'twilio-ruby'
require './twilio_stub'

def number(name) #looks up phone number for name in ENV
  ENV[name]
end

class PHS #utility namespace
  def self.development?
    !! ENV['development']
  end
  def self.production?
    !development?
  end
end

PHONE_TO_LOCATE = "+16502753739" # 1.650.275.EQDW
ORIGIN          = "+16505294993" # twilio number

ACCOUNT_SID = ENV['sid']
AUTH_TOKEN  = ENV['token']

CLIENT = TwilioFactory.get_client(ACCOUNT_SID, AUTH_TOKEN)

get '/' do
  erb :landing
end

get '/call_contents' do
  Twilio::TwiML::Response.new do |r|
    r.Say "I am trying to locate your phone. If you are hearing this, this means you found it"
  end.text
end

post '/call_contents' do
  Twilio::TwiML::Response.new do |r|
    r.Say "I am trying to locate your phone. If you are hearing this, this means you found it"
  end.text
end

post '/call' do
  puts "DEBUG: calling #{params[:name]} at #{number(params[:name])}"
  if number(params[:name])
    CLIENT.account.calls.create(
      :from => ORIGIN,
      :to   => number(params[:name]), 
      :url  => "#{ENV['heroku_url']}/call_contents"
    )
  end
end
