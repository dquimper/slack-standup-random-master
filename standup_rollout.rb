require 'slack-notifier'

class StandupRollout
  def initialize
    webhook_url = "https://hooks.slack.com/services/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"
    @notifier = Slack::Notifier.new webhook_url do
      defaults channel: "#slack-integration-tests",
               username: "StandupMaster"
    end
  end

  def notify(msg)
    # channel = "@U01PB4S6Z3J"
    channel = "#secret-media-business"
    # channel = "#slack-integration-tests"
    full_msg = "<!subteam^S01NS71FSR5|devs-media-biz> #{msg}"
    @notifier.ping full_msg, channel: channel
  end
end

standup_sm_list = [
  "Ittsel",
  "Francois",
  "Quy",
  "Frederic",
  "Guillaume",
  "Ranbir",
  "Aengus",
  "Dominique",
]

sm_name = standup_sm_list.sample

sr = StandupRollout.new
msg = "Today's randomly selected standup host is #{sm_name}"
sr.notify(msg)
puts msg
