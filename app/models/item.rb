class Item < ApplicationRecord
  include HasFlags

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
  validates :sale_price, presence: { message: 'Required for sold items' }, if: :sold
  validates :rejection_reason, absence: { message: "You must mark the item as rejected before filling this field" }, unless: :rejected

  #  =========
  #  = Flags =
  #  =========
  has_flags 1 => :in_stock

  #  =============
  #  = AR Scopes =
  #  =============
  scope :received, -> { where.not(date_received: nil) }
  scope :inventoried, -> { where("use_of_item_id = ?", UseOfItem.find_by_name("Inventory").id) }
  scope :sold, -> { inventoried.where.not(date_sold: nil) }

  #  ================
  #  = AR Callbacks  =
  #  ================
  before_save :check_update_inventory_number
  before_save :update_in_stock_flag

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

  def update_in_stock_flag
    self.in_stock = self.received? && self.use_of_item.inventory? && !self.sold?
  end

  #  ====================
  #  = Instance Methods =
  #  ====================
  def summary_description
    "#{item_type.department.name} - #{item_type.name}"
  end

  def full_description
    d = "#{item_type.department.name} - #{item_type.name}"
    d << " (#{inventory_number})" if inventory_number.present?
    d
  end

  def inventoried
    use_of_item.name == "Inventory" rescue false
  end
  alias :inventoried? :inventoried

  def received
    self.date_received.present?
  end
  alias :received? :received

  def sold
    self.inventoried && date_sold.present?
  end
  alias :sold? :sold

  def use_of_item_name
    "#{use_of_item.name}"
  end

  #  ========================================
  #  = aliases for default instance methods =
  #  ========================================
  def price
    regular_price
  end

private
  def inventory_number_generator
    same_day_items = Item.inventoried.where(item_type_id: item_type_id).where(date_received: date_received).to_a
    same_day_items.delete(self)
    item_type_day_count = same_day_items.length + 1
    date_string = date_received.strftime("%m%d%Y")
    "#{date_string}-#{item_type.code}#{item_type_day_count}"
  end

end
