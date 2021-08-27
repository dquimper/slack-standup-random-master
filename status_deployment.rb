require 'slack-notifier'

class DeploymentStatusNotification
  def initialize
    webhook_url = "https://hooks.slack.com/services/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"
    @notifier = Slack::Notifier.new webhook_url
  end

  def notify(msg)
    @notifier.ping msg
  end
end

sr = DeploymentStatusNotification.new
msg = "This is a test"
sr.notify(msg)
puts msg
