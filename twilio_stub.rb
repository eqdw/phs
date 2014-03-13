require 'pry'
class TwilioFactory
  def self.get_client(sid, token)
    if PHS.development?
      MockTwilioClient.new
    else
      Twilio::REST::Client.new(sid, token)
    end
  end
end

class MockTwilioClient
  def method_missing(*args, &block)
    # log that we were called
    puts "DEBUG: mock twilio client method #{args[0].to_s} called"
    puts "DEBUG: with parameters #{args[1..-1].join(", ")}"
    self
  end
end
