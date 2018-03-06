class ProjectsColors < BaseCollection
  attr_reader :date
  def initialize(date)
    @date = date
  end

  def fetch
    lazy_find('GarantME')
  end

  protected
  def load
    range = "#{HumanMonth[date]}!E24:E28"
    config.sheets_client
      .sheets(include_grid_data: true, ranges: range)
      .sheets[0].data[0].row_data
      .map do |row_data|
        name = row_data.values[0].formatted_value
        color = row_data.values[0].effective_format.background_color
        { name: name, color: color }
      end
  end

  def redis_key
    "projects_colors_#{HumanMonth[date]}"
  end

  def find_param
    'name'
  end
end