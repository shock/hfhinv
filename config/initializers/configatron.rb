require 'configatron'
require 'erb'
require 'yaml'

config_hash = YAML.load(ERB.new(File.read("#{Rails.root}/config/config.yml")).result)[Rails.env]
configatron.configure_from_hash(config_hash)
if ENV['CACHE_ENABLED'] == 'false'
  configatron.cache_settings.enabled = false
end
