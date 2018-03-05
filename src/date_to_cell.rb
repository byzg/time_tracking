class DateToCell
  attr_reader :date, :sheets_client

  def convert(date)
    date_pos = DatePos.new(date)
    {
      sheet_id: sheets[date_pos.human_month],
      start_row_index: date_pos.row,
      start_column_index: date_pos.col
    }
  end

  private
  def sheets
    @sheets ||= config.redis_service.fetch(:sheets) do
      config.sheets_client.sheets.sheets.map(&:properties).map do |property|
        [property.title, property.sheet_id]
      end.to_h
    end
  end



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
      @human_month ||= "#{I18n.l(date, format: '%B').mb_chars.downcase.to_s}#{date.year.to_s[2..3]}"
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
      @search_result = {}
      titles.map do |index, titles_row|
        if col = titles_row.index(date.strftime('%d.%m'))
          @search_result = { row: index.to_i, col: col.to_i }
        end
      end
      @search_result
    end

    def date; @date end
  end
end