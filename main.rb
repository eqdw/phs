require 'sinatra'
require 'sinatra/cookies'
require 'twilio-ruby'
require './twilio_stub'
require 'pry'

# from http://www.sinatrarb.com/faq.html#auth
helpers do

  def passwords
    ENV['PLAINTEXT_passwords'].split(",") #note: this app has shitty insecure password management. Proceed accordingly
  rescue #env variable not defined
    nil
  end


  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    if cookies[:password]  #check for saved auth token
      return passwords.include? cookies[:password]
    else #log in
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      if @auth.provided? and @auth.basic? and @auth.credentials #and @auth.credentials == ['admin', 'admin']
        # ignore username, because of laziness
        password = @auth.credentials[-1]
        if passwords.include? password
          cookies[:password] = password
          return true
        else
          redirect to('/jail') and return false
        end
      end
    end
  end
end

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

ORIGIN      = "+16505294993" # twilio number

ACCOUNT_SID = ENV['sid']
AUTH_TOKEN  = ENV['token']

CLIENT = TwilioFactory.get_client(ACCOUNT_SID, AUTH_TOKEN)

get '/' do
  protected!
  erb :landing
end

get '/jail' do
  "LOG IN NEXT TIME"
end

def call_contents
  Twilio::TwiML::Response.new do |r|
    r.Say "I am trying to locate your phone. If you are hearing this, this means you found it"
  end.text
end

get '/call_contents' do
  call_contents
end

post '/call_contents' do
  call_contents
end

post '/call' do
  protected!
  puts "DEBUG: calling #{params[:name]} at #{number(params[:name])}"
  if number(params[:name])
    CLIENT.account.calls.create(
      :from => ORIGIN,
      :to   => number(params[:name]), 
      :url  => "#{ENV['heroku_url']}/call_contents"
    )
  end
end
