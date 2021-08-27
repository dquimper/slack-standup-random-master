require 'slack-notifier'
require 'fileutils'

class StandupRollout
  def initialize
    # webhook_url = "https://hooks.slack.com/services/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"
    webhook_url = ENV["STANDUPROLLOUT_WEBHOOK_URL"].to_s
    raise "STANDUPROLLOUT_WEBHOOK_URL is undefined" if webhook_url.empty?
    @notifier = Slack::Notifier.new webhook_url do
      defaults channel: "#slack-integration-tests",
               username: "StandupMaster"
    end
  end

  def notify(msg)
    # channel = "@U01PB4S6Z3J"
    # channel = "#secret-media-business"
    # channel = "#secret-gcore"
    channel = ENV["STANDUPROLLOUT_CHANNEL"].to_s
    raise "STANDUPROLLOUT_CHANNEL is undefined" if channel.empty?
    at_handle = ENV["STANDUPROLLOUT_AT_HANDLE"].to_s
    raise "STANDUPROLLOUT_AT_HANDLE is undefined" if at_handle.empty?
    # channel = "#slack-integration-tests"
    # full_msg = "<!subteam^S01NS71FSR5|devs-media-biz> #{msg}"
    # full_msg = "<!subteam^S0281KVFRFS|gcore> #{msg}"
    full_msg = "#{at_handle} #{msg}"
    @notifier.ping full_msg, channel: channel
  end
end

standup_sm_list = ARGV
scrum_masters_file = "/tmp/standup_rollout/scrum_masters.json"
FileUtils.mkdir_p(File.dirname(scrum_masters_file))

begin
  selected_sm = JSON.parse(File.read(scrum_masters_file))
rescue Errno::ENOENT
  selected_sm = []
end

available_sm = standup_sm_list - selected_sm

if available_sm.empty?
  available_sm = standup_sm_list
  selected_sm = []
end

sm_name = available_sm.sample || "Nobody"
selected_sm << sm_name
File.write(scrum_masters_file, JSON.dump(selected_sm))

sr = StandupRollout.new
msg = "Today's randomly selected standup host is #{sm_name}"
sr.notify(msg)
puts msg
