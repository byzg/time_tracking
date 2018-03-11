require './src/config'

class TimeTracking
  def fill(date)
    time_tracks = config.kodep_timer_client.time_tracks(date)
    request = UpdateRequestBuilder::TimeTracks.build(time_tracks, date)
    config.sheets_client.write(request)
  end

  def run
    # config.redis_service.flushall
    scheduler = Rufus::Scheduler.new
    scheduler.every '30s' do
      (Date.new(2018, 02, 01)..Date.new(2018, 02, 7)).each do |date|
        config.logger.info ">>>>  Start filling #{date} #{'>' * 40}"
        begin
          fill(date)
        rescue DateNotFoundError
        end
        config.logger.info "<<<<  End   filling #{date} #{'<' * 40}"
        config.logger.info ''
      end
    end
    scheduler.join
  end
end
class DateNotFoundError < RuntimeError; end

app = TimeTracking.new
# app.fill(Date.today)
# app.run