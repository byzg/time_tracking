require 'bundler/setup'
Bundler.require
require './sheets_client'


class TimeTracking
  def run
    sheets_client = SheetsClient.new
    range = 'февраль18!B2:B4'
    sheets_client.get(range).values.each {|row| puts "#{row[0]}, #{row[4]}"}

    range = 'февраль18!A6:B6'
    values = [ ['se', 2.43] ]
    sheets_client.write(range, values)
  end
end

TimeTracking.new.run