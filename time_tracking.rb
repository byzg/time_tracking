require 'bundler/setup'
Bundler.require
require './secrects'
require './sheets_client'
require './kodep_timer_client'


class TimeTracking
  def run
    # p SECRETS
    # sheets_client = SheetsClient.new
    # range = 'февраль18!B2:B4'
    # sheets_client.get(range).values.each {|row| puts "#{row[0]}, #{row[4]}"}
    #
    # range = 'февраль18!A6:B6'
    # values = [ ['se', 2.43] ]
    # sheets_client.write(range, values)

    # p KodepTimerClient.new.time_tracks
  end
end

TimeTracking.new.run