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

  def initialize
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def get(range)
    service.get_spreadsheet_values(SPREADSHEET_ID, range)
  end

  def write(range, values)
    value_range_object = Google::Apis::SheetsV4::ValueRange.new(range: range, values: values)
    service.update_spreadsheet_value(SPREADSHEET_ID, range, value_range_object, value_input_option: 'USER_ENTERED')
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