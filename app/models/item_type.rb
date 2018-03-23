class ItemType < ApplicationRecord

  #  ===================
  #  = AR Associations =
  #  ===================
  belongs_to :department
  has_many :items

  #  ==================
  #  = AR Validations =
  #  ==================
  validates :department_id, presence: true

  #  ====================
  #  = Instance Methods =
  #  ====================
  def description
    "#{department.name} - #{name}"
  end

end
