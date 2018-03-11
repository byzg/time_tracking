module UpdateRequestBuilder
  class Base
    def self.build(range, grid)
      new(range, grid).request
    end
    attr_reader :request

    private
    ALPHABET = ('A'..'Z').each_with_index.map {|letter, i| [letter, i]}.to_h
    attr_reader :grid, :range
    def initialize(range, grid)
      @range = range.dup
      @grid = grid
      build_request
    end

    def build_request
      @request = {
        update_cells: {
          range: build_range,
          rows: build_rows,
          fields: 'userEnteredValue,userEnteredFormat.backgroundColor'
        }
      }
    end

    def build_range
      month = nil
      if @range.is_a?(Hash)
        month = HumanMonth[@range.delete(:date)]
        @range
      elsif @range.is_a?(String)
        month = @range.split('!')[0]
        indexes
      end.merge(sheet_id: sheets[month.to_sym])
    end

    def indexes
      if @range.is_a?(String)
        positions = @range.split('!')[1].scan(/([A-Z])|(\d+)/).flatten.compact
        {
          start_row_index: positions[1].to_i,
          start_column_index: ALPHABET[positions[0]].to_i,
          end_row_index: positions[3].to_i + 1,
          end_column_index: ALPHABET[positions[2]].to_i + 1
        }
      end
    end

    def build_rows
      @grid.map do |row|
        values = row.map do |col|
          if col.is_a?(Hash) && col[:value]
            cell = { user_entered_value: { string_value: col[:value] } }
            cell.merge!(user_entered_format: { background_color: col[:color] }) if col[:color]
            cell
          elsif col.is_a?(Hash)
            col
          else
            { user_entered_value: { string_value: col } }
          end
        end
        { values: values }
      end
    end

    def sheets
      @sheets ||= config.redis_service.fetch(:sheets) do
        config.sheets_client.sheets.sheets.map(&:properties).map do |property|
          [property.title, property.sheet_id]
        end.to_h
      end
    end
  end
end