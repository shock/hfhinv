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
  validates :name, presence: true, uniqueness: {scope: :department}
  validates :code, presence: true, uniqueness: true

  #  =================
  #  = Class Methods =
  #  =================
  def self.all_sorted
    item_types = []
    Department.all.order(:name).each do |department|
      department.item_types.order(:name).each do |item_type|
        item_types << item_type
      end
    end
    item_types
  end

  #  ====================
  #  = Instance Methods =
  #  ====================
  def description
    "#{department.name} - #{name}"
  end

end
