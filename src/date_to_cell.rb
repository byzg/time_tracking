class DateToCell
  attr_reader :date, :sheets_client
  def initialize(sheets_client)
    @date = date
    @sheets_client = sheets_client
  end

  def convert(date)
    p sheets
    { sheet_id: 0, start_row_index: 0, start_column_index: 0 }
  end

  private
  def sheets
    config.redis_service.fetch(:sheets) do
      sheets_client.sheets.sheets.map(&:properties).map do |property|
        [property.title, property.sheet_id]
      end.to_h
    end
  end

  def month
    @month ||= "#{I18n.l(date, format: '%B').mb_chars.downcase.to_s}#{date.year.to_s[2..3]}!"
  end

  def date_xy_start
    row, col = nil, nil
    [1, 12].map do |_row|
      break if col
      row = _row
      col = index_of(to_m("A#{row}:X#{row}"), date.strftime('%d.%m'))
    end
    to_m("#{('A'..'Z').to_a[col]}#{row + 1}")
  end

  def index_of(range, value)
    sheets_client.get(range).values[0].index(value)
  end

  def to_m(range)
    "#{month}#{range}"
  end
end