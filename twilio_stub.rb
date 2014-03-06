class TwilioFactory
  def self.get_client(sid, token)
    if development?
      MockTwilioClient.new
    else
      Twilio::REST::Client.new(sid, token)
    end
  end
end

class MockTwilioClient

  # this is so hacky
  def account
    act = Object.new

    # WHAT HAVE I DONE
    # I hate myself
    def act.calls

      # OH GOD WHY
      cls = Object.new

      def cls.create(opts={})
        nil
      end

      cls
    end

    act
  end
end
