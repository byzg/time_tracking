require 'bundler/setup'
Bundler.require
require 'active_support'
require 'active_support/core_ext'
require './src/secrects'
require './src/sheets_client'
require './src/kodep_timer_client'
require './src/date_to_cell'
require './src/redis_service'
require './src/update_cells_request_builder'

I18n.default_locale = :ru

class Config

  def sheets_client
    @sheets_client ||= SheetsClient.new
  end

  def kodep_timer_client
    @kodep_timer_client ||= KodepTimerClient.new
  end

  def date_to_cell
    @date_to_cell ||= DateToCell.new
  end

  def redis_service
    @redis_service ||= RedisService.new
  end

  def logger
    return @logger if @logger
    file = File.open('logfile.log', 'w')
    @logger = Logger.new(STDOUT || file)
  end
end

def config
  @config ||= Config.new
end