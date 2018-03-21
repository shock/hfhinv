class ItemType < ApplicationRecord
  belongs_to :department
  has_many :items

  def description
    "#{department.name} - #{name}"
  end
end
