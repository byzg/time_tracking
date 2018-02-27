require 'multi_json'
File.open('secrets.json') do |f|
  SECRETS = ActiveSupport::HashWithIndifferentAccess.new(MultiJson.load(f.read).symbolize_keys)
end