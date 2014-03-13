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
    self
  end
end
