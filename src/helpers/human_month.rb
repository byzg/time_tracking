class HumanMonth
  def self.[](date)
    "#{I18n.l(date, format: '%B').mb_chars.downcase.to_s}#{date.year.to_s[2..3]}"
  end
end