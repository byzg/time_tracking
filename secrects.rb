require 'multi_json'
require 'active_support'
require 'active_support/core_ext'
File.open('secrets.json') do |f|
  SECRETS = ActiveSupport::HashWithIndifferentAccess.new(MultiJson.load(f.read).symbolize_keys)
end