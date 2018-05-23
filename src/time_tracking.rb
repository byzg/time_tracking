require './src/config'

class TimeTracking
  def fill(date)
    time_tracks = config.kodep_timer_client.time_tracks(date)
    request = UpdateRequestBuilder::TimeTracks.build(time_tracks, date)
    config.sheets_client.write(request) if time_tracks.present?
  end

  def run
    # config.redis_service.flushall
    scheduler = Rufus::Scheduler.new
    scheduler.cron '0 4 * * *' do
      date = Date.yesterday
      config.logger.info ">>>>  Start filling #{date} #{'>' * 40}"
      begin
        fill(date)
      rescue DateNotFoundError
      end
      config.logger.info "<<<<  End   filling #{date} #{'<' * 40}"
      config.logger.info ''
    end
    config.logger.info 'TimeTracking has been started.'
    scheduler.join
  end
end
class DateNotFoundError < RuntimeError; end

app = TimeTracking.new
# app.fill(Date.today)
app.run
