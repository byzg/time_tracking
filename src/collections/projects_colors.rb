class ProjectsColors < BaseCollection
  COL = 'E'
  ROW_FIRST = 24
  ROW_LAST = 28
  attr_reader :date
  def initialize(date)
    @date = date
  end

  def fetch(project_name)
    project = lazy_find(project_name)
    return project if project
    project = lazy_find(nil)
    index = index(project)
    range = "#{HumanMonth[date]}!#{COL}#{ROW_FIRST + index - 1}:#{COL}#{ROW_FIRST + index - 1}"
    request = UpdateRequestBuilder::Base.build(
      range, [[{value: project_name, color: project[:color]}]]
    )
    config.sheets_client.write(request)
    lazy_find(project_name)
  end

  protected
  def load
    config.sheets_client
      .sheets(include_grid_data: true, ranges: load_range)
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
    :name
  end

  def load_range
    "#{HumanMonth[date]}!#{COL}#{ROW_FIRST}:#{COL}#{ROW_LAST}"
  end
end