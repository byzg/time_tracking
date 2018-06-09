class DateToCell
  attr_reader :date, :sheets_client

  def convert(date)
    date_pos = DatePos.new(date)
    {
      date: date,
      start_row_index: date_pos.row,
      start_column_index: date_pos.col
    }
  end

  private

  class DatePos
    def initialize(date)
      @date = date
    end

    def row
      @row ||= search[:row]
    end

    def col
      @col ||= search[:col]
    end

    def human_month
      @human_month ||= HumanMonth[date]
    end

    private
    def titles
      @titles ||= config.redis_service.fetch("titles_#{human_month}") do
        [1, 12].map do |row_index|
          [row_index, config.sheets_client.get("#{human_month}!A#{row_index}:X#{row_index}").values[0]]
        end.to_h
      end
    end

    def search
      return @search_result if @search_result
      @search_result = nil
      titles.map do |index, titles_row|
        if col = titles_row.index(date.strftime('%d.%m'))
          @search_result = { row: index.to_s.to_i, col: col.to_s.to_i }
        end
      end
      raise DateNotFoundError.new(@date) unless @search_result
      @search_result
    end

    def date; @date end
  end
end