module UpdateRequestBuilder
  class Cells
    def self.build(time_tracks, cell_for_date)
      instance = new(time_tracks, cell_for_date)
      UpdateRequestBuilder::Base.new(instance.range, instance.rows)
    end

    def range
      @cell_for_date.merge(
        end_row_index: @cell_for_date[:start_row_index] + 3,
        end_column_index: @cell_for_date[:start_column_index] + @time_tracks.size
      )
    end

    def rows
      @time_tracks.map do |time_track|
        [
          { user_entered_value: { string_value: time_track[:task_name] } },
          { user_entered_value: { number_value: (time_track[:duration].to_f / 60).round(2) } }
        ]
      end
    end

    private
    def initialize(time_tracks, cell_for_date)
      @time_tracks, @cell_for_date = time_tracks, cell_for_date
    end
    attr_reader :time_tracks, :cell_for_date
  end
end