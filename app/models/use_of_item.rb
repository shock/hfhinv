class UseOfItem < ApplicationRecord
  has_many :items
  USES_OF_ITEM = ["Inventory", "Recycle", "Donate", "Use In Store", "Discard"]
end
