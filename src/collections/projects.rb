class Projects < BaseCollection
  def fetch(date, id)
    project = lazy_find(id)
    projects_colors = ProjectsColors.new(date)
    projects_colors.fetch('GarantME_Front')
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