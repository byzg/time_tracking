require 'bundler/setup'
Bundler.require
require 'active_support'
require 'active_support/core_ext'

{
  helpers: %i(date_to_cell human_month logger_helper secrets),
  services: %i(redis_service update_cells_request_builder),
  collections: %i(base_collection projects projects_colors),
  app: %i(sheets_client kodep_timer_client)
}.each_pair { |k, files| files.each {|file| require "./src/#{k}/#{file}" } }

I18n.default_locale = :ru
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'projects', 'projects'
end

class Config
  DEFINED = %i(sheets_client kodep_timer_client date_to_cell redis_service projects)
  attr_accessor :_log_pause

  def method_missing(name)
    if DEFINED.include?(name.to_sym)
      var_name = "@#{name}"
      config_instance = name.to_s.classify.constantize.new
      instance_variable_get(var_name) || instance_variable_set(var_name, config_instance)
    else
      super(name)
    end
  end

  def logger
    return @logger if @logger
    file = File.open('logfile.log', 'w')
    @logger = Logger.new(STDOUT || file)
  end

  def log_pause
    self._log_pause = true
    yield
    self._log_pause = false
  end
end


$config = Config.new
def config
  $config
end