require 'rest-client'

class KodepTimerClient
  include LoggerHelper
  API_ROOT = 'https://timer.kodep.ru/api'
  def initialize
    config.log_pause do
      @headers = config.redis_service.fetch(:cookie) do
        { cookie: "Auth-Token=#{auth_response[:auth_token]}" }
      end
    end
  end

  def time_tracks(date)
    date = date.strftime('%Y-%m-%d')
    execute('/time_tracks', :get,{
      q: { tracking_date_gteq: date, tracking_date_lteq: date, limit: 1000 }
    })[:time_tracks]
  end

  def projects
    execute('/projects', :get)[:projects]
  end

  private
  def auth_response
    execute('/sessions', :post, SECRETS[:kodep_timer])
  end

  def execute(path, method, payload = {})
    log("Request #{method.upcase} #{API_ROOT}#{path}. Response:") do
      parse(RestClient::Request.execute(
        method: method,
        url: "#{API_ROOT}#{path}",
        payload: payload,
        headers: @headers
      ))
    end
  end

  def parse(response)
    ActiveSupport::HashWithIndifferentAccess.new(JSON.parse(response.body))
  end
end