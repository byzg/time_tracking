require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

class SheetsClient
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
  APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'
  CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                               "sheets.googleapis.com-ruby-quickstart.yaml")
  SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
  SPREADSHEET_ID = '1koPtuzH9CDf3Wf_9ar5Td0UJVKdasv2gTeryjKL2iKg'
  # '1iPngiFuXQFRQMy5Oyhn9okO6_ayIVQE3irKBKYmSf78'
  # '1koPtuzH9CDf3Wf_9ar5Td0UJVKdasv2gTeryjKL2iKg'



  def initialize
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
    Google::Apis.logger = config.logger
  end

  def get(range)
    service.get_spreadsheet_values(SPREADSHEET_ID, range)
  end

  def write(range, values)
    # value_range_object = Google::Apis::SheetsV4::ValueRange.new(range: 'февраль18!M14', values: [['qwe']])
    # service.update_spreadsheet_value(SPREADSHEET_ID, 'февраль18!M14', value_range_object, value_input_option: 'USER_ENTERED')

    # data = Google::Apis::SheetsV4::ValueRange.new( range: 'февраль18!M14', values: [['qwe']] )
    # batch_update_values = Google::Apis::SheetsV4::BatchUpdateValuesRequest.new(data: data, value_input_option: 'USER_ENTERED')
    # batch_update_values = {
    #                  "updateSpreadsheetProperties": {
    #                    "properties": {"title": "My New Title"},
    #                    "fields": "title"
    #                  }
    #
    # }.to_json
    # service.batch_update_values(SPREADSHEET_ID, batch_update_values, options: { skip_serialization: true })
    requests = []
# Change the name of sheet ID '0' (the default first sheet on every
# spreadsheet)
    requests.push({
                    "update_cells": {
                      # "start": {
                      #   "sheet_id": 0,
                      #   "row_index": 0,
                      #   "column_index": 0
                      # },
                      range: {
                        "sheet_id": 0,
                        "start_row_index": 2,
                        "end_row_index": 4,
                        "start_column_index": 1,
                        "end_column_index": 7,
                      },
                      "rows": [
                        {
                          "values": [
                            {
                              "user_entered_value": {"number_value": 1},
                              "user_entered_format": {"background_color": {"red": 1}}
                            }, {
                              "user_entered_value": {"number_value": 2},
                              "user_entered_format": {"background_color": {"blue": 1}}
                            }, {
                              "user_entered_value": {"number_value": 3},
                              "user_entered_format": {"background_color": {"green": 1}}
                            }, {
                              "user_entered_value": {"number_value": 7}
                            }, {
                              "user_entered_value": {"number_value": 3},
                              "user_entered_format": {"background_color": {"green": 1}}
                            }
                          ]
                        },
                        {
                          "values": [
                            {
                              "user_entered_value": {"number_value": 1},
                              "user_entered_format": {"background_color": {"red": 1}}
                            }
                          ]
                        }
                      ],
                      "fields": "userEnteredValue,userEnteredFormat.backgroundColor"
                    }
                  })
# Add additional requests (operations) ...

    body = {requests: requests}
    result = service.batch_update_spreadsheet(SPREADSHEET_ID, body, {})
    # find_replace_response = result.replies[1].find_replace
    # puts "#{find_replace_response.occurrences_changed} replacements made."
    p result
  end

  def sheets
    service.get_spreadsheet(SPREADSHEET_ID)
  end

  def get_projects_and_colors(date)
    range = RangeFormatter.new(date, self).to_m('E24:E28')
    service
      .get_spreadsheet(SPREADSHEET_ID, include_grid_data: true, ranges: range)
      .sheets[0].data[0].row_data.map do |row_data|
      formatted_value = row_data.values[0].formatted_value
      next unless formatted_value
      name, id = formatted_value.split('#')
      color = row_data.values[0].effective_format.background_color
      [id, { name: name, color: color }]
    end.compact.to_h
  end

  private
  def service
    @service
  end

  def authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_hash(SECRETS[:sheets])
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(
        client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts 'Open the following URL in the browser and enter the resulting code after authorization'
      puts url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: OOB_URI)
    end
    credentials
  end
end