class RangeFormatter
  attr_reader :date, :sheets_client
  def initialize(date, sheets_client)
    @date = Date.parse(date.to_s)
    @sheets_client = sheets_client
  end

  def month
    @month ||= "#{I18n.l(date, format: '%B').mb_chars.downcase.to_s}#{date.year.to_s[2..3]}!"
  end

  def date_col
    col = nil
    [1, 12].map do
      break if col
      col = index_of(to_m('A1:X1'), date.strftime('%d.%m'))
    end
    ('A'..'Z').to_a[col]
  end

  def index_of(range, value)
    sheets_client.get(range).values[0].index(value)
  end

  def to_m(range)
    "#{month}#{range}"
  end
end