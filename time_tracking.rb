require 'bundler/setup'
Bundler.require
require 'active_support'
require 'active_support/core_ext'
require './secrects'
require './sheets_client'
require './kodep_timer_client'
require './range_formatter'

I18n.default_locale = :ru

class TimeTracking
  attr_reader :sheets_client
  def initialize
    @sheets_client = SheetsClient.new
  end

  def fill(date)
    range_formatter = RangeFormatter.new(date, @sheets_client)
    p range_formatter.date_col
    # sheets_client.write("#{range_month}#{col}2", [[123]])
  end

  def run
    # p KodepTimerClient.new.time_tracks
    fill('09.02.2018')
  end
end

TimeTracking.new.run