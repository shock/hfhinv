class Item < ApplicationRecord
  belongs_to :pickup
  belongs_to :item_type, optional: true
  belongs_to :use_of_item, optional: true
end
