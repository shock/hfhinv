class ZipCode < ActiveRecord::Base
  ZIP_REGEX = /\A\d{5}(?:-\d{4})?\Z/

  geocoded_by :zipcode
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.reload
      obj.city      = geo.city
      obj.state     = geo.state_code
      obj.zipcode   = geo.postal_code
      obj.longitude = geo.longitude
      obj.latitude  = geo.latitude
      county_desc   = geo.data["address_components"].select{|e| e["types"][0] == "administrative_area_level_2"}.first rescue nil
      county_name   = county_desc["long_name"].gsub(/County/i, '').strip rescue nil
      obj.county    = county_name
    end
  end
  after_validation :reverse_geocode

  after_validation :geocode, if: ->(obj) { obj.zipcode.present? and (obj.zipcode_changed? or obj.new_record?) }

  validates :zipcode, format: { with: ZIP_REGEX }, allow_blank: false
  has_many :donors, foreign_key: :zip, primary_key: :zipcode
  has_many :donations, through: :donors

  def self.in_radius(zipcode, radius_miles=50)
    near(zipcode.to_s, radius_miles)
  end

  comma do
    zipcode
    city
    county
    state
    latitude
    longitude
    timezone_offset
    timezone_dst
    timezone
  end

end