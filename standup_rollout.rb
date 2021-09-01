require 'slack-notifier'
require 'fileutils'

class StandupRollout
  def initialize
    webhook_url = ENV["STANDUPROLLOUT_WEBHOOK_URL"].to_s
    raise "STANDUPROLLOUT_WEBHOOK_URL is undefined" if webhook_url.empty?
    @notifier = Slack::Notifier.new webhook_url do
      defaults channel: "#slack-integration-tests",
               username: "StandupMaster"
    end
  end

  def channel
    c = ENV["STANDUPROLLOUT_CHANNEL"].to_s # example: #slack-integration-tests
    raise "STANDUPROLLOUT_CHANNEL is undefined" if c.empty?
    c
  end

  def at_handle
    h = ENV["STANDUPROLLOUT_AT_HANDLE"].to_s # example: <!subteam^S01NS71FSR5|my-group>
    raise "STANDUPROLLOUT_AT_HANDLE is undefined" if h.empty?
    h
  end

  def notify(msg)
    full_msg = "#{at_handle} #{msg}"
    @notifier.ping full_msg, channel: channel
  end
end

class StandupSmList
  def initialize
    manage_past_scrum_master do |selected_sm|
      msg = "Today's randomly selected standup host is #{selected_sm}"
      sr = StandupRollout.new
      sr.notify(msg)
      puts msg
    end
  end

  def team
    @_team ||= ENV["STANDUPROLLOUT_TEAM"].split(/ +/)
    raise "STANDUPROLLOUT_TEAM is undefined" if @_team.empty?
    @_team
  end

  def manage_past_scrum_master
    scrum_masters_file = "/tmp/standup_rollout/scrum_masters.json"
    FileUtils.mkdir_p(File.dirname(scrum_masters_file))

    begin
      past_sm = JSON.parse(File.read(scrum_masters_file))
    rescue Errno::ENOENT
      past_sm = []
    end

    available_sm = team - past_sm
    if available_sm.empty?
      available_sm = team
      past_sm = []
    end

    selected_sm = available_sm.sample || "Nobody"

    past_sm << selected_sm
    File.write(scrum_masters_file, JSON.dump(past_sm))

    yield(selected_sm)
  end
end

if __FILE__ == $0
  StandupSmList.new
end
