require './src/config'

class TimeTracking
  def fill(date)
    time_tracks = config.kodep_timer_client.time_tracks(date)
    cell_for_date = config.date_to_cell.convert(date)
    request = UpdateCellsRequestBuilder.build(time_tracks, cell_for_date)
    config.sheets_client.write(request)
  end

  def get_projects_and_colors(date)
    config.sheets_client.get_projects_and_colors(date)
  end

  def run
    date = Date.parse('26.02.2018'.to_s)
    # config.redis_service.flushall
    # p config.projects.fetch(date, 81)
    # fill(date)
    # p get_projects_and_colors(date)
  end
end

TimeTracking.new.run