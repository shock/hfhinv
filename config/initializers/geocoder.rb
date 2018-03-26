# config/initializers/geocoder.rb
require 'geocoder'

redis_url = configatron.geocoder.redis.url
redis_url ||= configatron.redis.url

Rails.logger.warn 'MISSING GEOCODER REDIS URL' unless redis_url.present?

Geocoder.configure(

  # Make requests using SSL
  #use_https: false
  use_https: true,

  # Geocoding service:
  lookup: :google,

  # IP address geocoding service (see below for supported options):
  #ip_lookup: :freegeoip,
  # ip_lookup: :geocodeip,

  # to use an API key:
  #api_key: nil,
  api_key: configatron.geocoder.google_api_key,

  # geocoding service request timeout, in seconds (default 3):
  timeout: 3,

  # set default units to kilometers:
  units: :mi,

  # caching (see below for details):
  # cache: nil,
  # cache: Redis.new({
  #   url: redis_url,
  #   namespace:  "#{Rails.application.class.parent.name} #{Rails.env} geocoder".slugify
  # }),
  # cache_prefix: "geocoder:"
)
