class Department < ApplicationRecord
  has_many :item_types, dependent: :destroy
  has_many :items, through: :item_types

  validates :name, presence: true
end
