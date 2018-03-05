class Projects < Array
  def fetch(date, id)
    project = find(id) || (pull && find(id)) || (pull! && find(id))
  end

  private
  def find(id)
    detect {|project| project[:id] == id }
  end

  def pull
    config.redis_service.fetch(:projects) do
      config.kodep_timer_client.projects
    end.each {|project| push(project) unless find(project[:id]) }
  end

  def pull!
    config.redis_service[:projects] = config.kodep_timer_client.projects
    pull
  end
end