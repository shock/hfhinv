class ZipCode < ActiveRecord::Base
  geocoded_by :zipcode
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, if: ->(obj) { obj.zipcode.present? and (obj.zipcode_changed? or obj.new_record?) }

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