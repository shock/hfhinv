class Pickup < ApplicationRecord
  belongs_to :donor
  has_many :items
end
