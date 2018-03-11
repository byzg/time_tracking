class Projects < BaseCollection
  def fetch(date, id)
    project = lazy_find(id)
    projects_colors = ProjectsColors.new(date)
    project.merge(projects_colors.fetch(project[:title]).to_h)
  end

  protected
  def load
    config.kodep_timer_client.projects
  end

  def redis_key
    :projects
  end

  def find_param
    :id
  end
end