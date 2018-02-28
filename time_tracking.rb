require 'bundler/setup'
Bundler.require
require 'active_support'
require 'active_support/core_ext'
require './secrects'
require './sheets_client'
require './kodep_timer_client'
require './range_formatter'
require './redis_service'

I18n.default_locale = :ru

class TimeTracking
  attr_reader :sheets_client, :kodep_timer_client
  def initialize
    @sheets_client = SheetsClient.new
    @kodep_timer_client = KodepTimerClient.new
  end

  def fill(date)
    date = Date.parse(date.to_s)
    values = kodep_timer_client.time_tracks(date).map do |time_track|
      [time_track[:task_name], (time_track[:duration].to_f / 60).round(2)]
    end
    range_formatter = RangeFormatter.new(date, sheets_client)
    range = range_formatter.date_xy_start
    sheets_client.write(range, values)
  end

  def get_projects_and_colors(date)
    sheets_client.get_projects_and_colors(date)
  end

  def run
    date = Date.parse('26.02.2018'.to_s)
    # redis_service = RedisService.new
    # redis_service.redis.del('test')
    # redis_service[:test] = { foo: :bar }
    # p redis_service[:test]
    # p redis_service.fetch('test', { foo: :bar })
    # fill(date)
    sheets_client.write(1, 1)
    # p get_projects_and_colors(date)
  end
end

TimeTracking.new.run