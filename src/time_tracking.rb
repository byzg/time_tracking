require './src/config'

class TimeTracking
  def fill(date)
    time_tracks = config.kodep_timer_client.time_tracks(date)
    request = UpdateRequestBuilder::TimeTracks.build(time_tracks, date)
    config.sheets_client.write(request)
  end

  def run
    config.redis_service.flushall
    (Date.new(2018, 02, 01)..Date.new(2018, 02, 28)).each do |date|
      begin
        fill(date)
      rescue DateNotFoundError
      end
    end
  end
end
class DateNotFoundError < RuntimeError; end

TimeTracking.new.run