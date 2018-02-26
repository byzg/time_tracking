require 'rest-client'
class KodepTimerClient
  API_ROOT = 'https://timer.kodep.ru/api'
  def initialize
    @headers = { cookie: "Auth-Token=#{auth_response[:auth_token]}" }
  end

  def time_tracks
    date = Date.yesterday.strftime('%Y-%m-%d')
    execute('/time_tracks', :get,{
      q: { tracking_date_gteq: date, tracking_date_lteq: date, limit: 1000 }
    })[:time_tracks]
  end

  private
  def auth_response
    execute('/sessions', :post, SECRETS[:kodep_timer])
  end

  def execute(path, method, payload = {})
    parse(RestClient::Request.execute(
      method: method,
      url: "#{API_ROOT}#{path}",
      payload: payload,
      headers: @headers
    ))
  end

  def parse(response)
    ActiveSupport::HashWithIndifferentAccess.new(JSON.parse(response.body))
  end
end