require './src/config'

class TimeTracking
  attr_reader :sheets_client, :kodep_timer_client, :date_to_cell
  def initialize
    @sheets_client = SheetsClient.new
    @kodep_timer_client = KodepTimerClient.new
    @date_to_cell = DateToCell.new(sheets_client)
  end

  def fill(date)
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
    # config.redis_service.flushall
    p config.date_to_cell.convert(date)
    # redis_service = RedisService.new
    # redis_service.redis.del('test')
    # redis_service[:test] = { foo: :bar }
    # p redis_service[:test]
    # p redis_service.fetch('test', { foo: :bar })
    # fill(date)
    # sheets_client.write(1, 1)
    # p get_projects_and_colors(date)

  end
end

TimeTracking.new.run