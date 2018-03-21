class Donation < ApplicationRecord
  belongs_to :donor
  has_many :items

  def description
    "#{donor.full_name} - #{pickup_date}"
  end
end
