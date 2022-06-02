require 'slack-notifier'
require 'fileutils'

class SlackNotifier
  def initialize
    webhook_url = ENV["SLACK_NOTIFIER_WEBHOOK_URL"].to_s
    raise "SLACK_NOTIFIER_WEBHOOK_URL is undefined" if webhook_url.empty?
    @notifier = Slack::Notifier.new webhook_url do
      defaults channel: "#slack_notifier",
               username: "SlackNotifier"
    end
  end

  def channel
    c = ENV["SLACK_NOTIFIER_CHANNEL"].to_s # example: #slack-integration-tests
    raise "SLACK_NOTIFIER_CHANNEL is undefined" if c.empty?
    c
  end

  def at_handle
    h = ENV["SLACK_NOTIFIER_AT_HANDLE"].to_s # example: <!subteam^S01NS71FSR5|my-group>
    raise "SLACK_NOTIFIER_AT_HANDLE is undefined" if h.empty?
    h
  end

  def notify(msg, at_mention = at_handle)
    full_msg = [at_mention, msg].compact.join(" ")
    @notifier.ping full_msg, channel: channel
  end
end

class StandupOrder
  def initialize
    msg = "Today's randomly selected standup order is: #{ARGV.shuffle.join(", ")}"
    sr = SlackNotifier.new
    sr.notify(msg, nil)
    puts msg
  end
end

if __FILE__ == $0
  StandupOrder.new
end
