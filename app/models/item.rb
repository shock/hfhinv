class Item < ApplicationRecord
  belongs_to :pickup
  belongs_to :dropoff
  belongs_to :item_type
  belongs_to :use_of_item
end
