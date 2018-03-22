class Item < ApplicationRecord

  #  ===================
  #  = AR Associations =
  #  ===================
  belongs_to :donation
  belongs_to :item_type, optional: true
  belongs_to :use_of_item, optional: true

  #  ==================
  #  = AR Validations =
  #  ==================
  validates :rejection_reason, presence: { message: 'Required when rejected' }, if: :rejected
  validates :description, presence: { message: 'Required for inventoried items' }, if: :inventoried
  validates :regular_price, presence: { message: 'Required for inventoried items' }, if: :inventoried
  validates :date_received, presence: { message: 'Required for inventoried items' }, if: :inventoried
  validates :rejection_reason, absence: { message: "You must mark the item as rejected before filling this field" }, unless: :rejected

  #  ================
  #  = AR Callbacks  =
  #  ================
  before_save :check_update_inventory_number

  def check_update_inventory_number
    if use_of_item_id_changed?
      if item_type.present? && received?
        if inventoried?
          self.inventory_number = inventory_number_generator
        else
          self.inventory_number = nil
        end
      end
    end
  end
  private :check_update_inventory_number

  #  ====================
  #  = Instance Methods =
  #  ====================
  def summary_description
    "#{item_type.department.name} - #{item_type.name}"
  end

  def inventoried
    use_of_item.name == "Inventory" rescue false
  end
  alias :inventoried? :inventoried

  def received
    self.date_received.present?
  end
  alias :received? :received


private
  def inventory_number_generator
    type_count = Item.where(item_type_id: item_type_id).where(date_received: date_received).count
    unless Item.find_by_id(self.id)
      type_count +=1
    end
    date_string = date_received.strftime("%m%d%Y")
    "#{date_string}-#{item_type.code}#{type_count}"
  end

end
