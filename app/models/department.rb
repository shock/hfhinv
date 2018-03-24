class Department < ApplicationRecord
  has_many :item_types

  validates :name, presence: true
end
