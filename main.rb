require 'sinatra'
require 'twilio-ruby'

PHONE_TO_LOCATE = "+16502753739" # 1.650.275.EQDW
ORIGIN          = "+16505294993" # twilio number

ACCOUNT_SID = ENV['sid']
AUTH_TOKEN  = ENV['token']

CLIENT = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)

get '/' do
  erb :landing
end

get '/call_contents' do
  Twilio::TwiML::Response.new do |r|
    r.Say "I am trying to locate your phone. If you are hearing this, this means you found it"
  end.text
end

get '/call' do
  CLIENT.account.calls.create(
    :from => ORIGIN,
    :to   => PHONE_TO_LOCATE,
    :url  => "http://thawing-shore-7556.herokuapp.com/call_contents"
  )
end
