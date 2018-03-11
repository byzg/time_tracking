module UpdateRequestBuilder
  class TimeTracks
    def self.build(time_tracks, date)
      instance = new(time_tracks, date)
      UpdateRequestBuilder::Base.build(instance.range, instance.rows)
    end

    def range
      cell_for_date.merge(
        end_row_index: cell_for_date[:start_row_index] + @time_tracks.size,
        end_column_index: cell_for_date[:start_column_index] + 3
      )
    end

    def rows
      @time_tracks.map do |time_track|
        color = config.projects.fetch(date, time_track[:project_id])[:color]
        [
          {
            user_entered_value: { string_value: time_track[:task_name] },
            user_entered_format: { background_color: color }
          },
          { user_entered_value: { number_value: (time_track[:duration].to_f / 60).round(2) } }
        ]
      end
    end

    private
    def initialize(time_tracks, date)
      cell_for_date = config.date_to_cell.convert(date)
      @time_tracks, @date, @cell_for_date = time_tracks, date, cell_for_date
    end
    attr_reader :time_tracks, :cell_for_date, :date
  end
end