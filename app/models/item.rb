class Item < ApplicationRecord
  include HasFlags

  #  ===================
  #  = AR Associations =
  #  ===================
  belongs_to :donation, optional: true, counter_cache: true
  belongs_to :item_type, optional: true, counter_cache: true
  belongs_to :use_of_item, optional: true, counter_cache: true
  has_one :department, through: :item_type

  #  ======================
  #  = Virtual Attributes =
  #  ======================
  attr_accessor :new_item_type_department_id, :new_item_type_name, :new_item_type_code, :new_item_type_notes

  #  ==================
  #  = AR Validations =
  #  ==================
  validates :item_type_id, presence: { message: "You must select and item type" }
  validates :donation_id, presence: { message: "Required for donated items" }, if: :donated
  validates :rejection_reason, presence: { message: 'Required when rejected' }, if: :rejected
  validates :description, presence: { message: 'Required for inventoried items' }, if: :inventoried
  validates :regular_price, presence: { message: 'Required for inventoried items' }, if: :inventoried
  validates :date_received, presence: { message: 'Required for inventoried items' }, if: :inventoried
  validates :sale_price, presence: { message: 'Required for sold items' }, if: :sold
  validates :rejection_reason, absence: { message: "You must mark the item as rejected before filling this field" }, unless: :rejected
  validates :new_item_type_name, presence: true, if: :creating_new_item_type?
  validates :new_item_type_code, presence: true, if: :creating_new_item_type?
  #  =========
  #  = Flags =
  #  =========
  has_flags 1 => :in_stock,
            2 => :donated

  #  =============
  #  = AR Scopes =
  #  =============
  scope :received, -> { where.not(date_received: nil) }
  scope :inventoried, -> {
    joins(:item_type).where("use_of_item_id = ?", UseOfItem.find_by_name("Inventory").id).
      where("item_types.code IS NOT NULL AND item_types.code != ''")
  }
  scope :sold, -> { inventoried.where.not(date_sold: nil) }

  #  ================
  #  = AR Callbacks  =
  #  ================
  before_validation :check_for_new_item_type
  before_save :check_update_inventory_number
  before_save :update_in_stock_flag

  def check_for_new_item_type
    if self.new_item_type_department_id.present?
      self.new_item_type_name = new_item_type_name.titleize
      self.new_item_type_code = new_item_type_code.gsub(/\d+\Z/, '')
      item_type = ItemType.find_or_create_by(department_id: new_item_type_department_id, name: new_item_type_name, code: new_item_type_code)
      item_type.notes = new_item_type_notes
      item_type.notes = 'brief description' unless item_type.notes.present?
      item_type.save!
      self.item_type = item_type
    else
    end
  end
  private :check_for_new_item_type

  def check_update_inventory_number
    if use_of_item_id_changed? || item_type_id_changed?
      if item_type.present? && received?
        if inventoried? && item_type.code.present?
          self.inventory_number = inventory_number_generator
        else
          self.inventory_number = nil
        end
      end
    end
  end
  private :check_update_inventory_number

  def update_in_stock_flag
    self.in_stock = self.received? &&
      self.use_of_item.present? &&
      self.use_of_item.inventory? &&
      self.item_type.code.present? &&
      !self.sold?
  end

  #  ====================
  #  = Instance Methods =
  #  ====================

  def display_name
    self.id
  end

  def summary_description
    "#{item_type.department.name} - #{item_type.name}"
  end

  def full_description
    d = "#{item_type.department.name} - #{item_type.name}"
    d << " (#{inventory_number})" if inventory_number.present?
    d
  end

  def inventoried
    use_of_item.name == "Inventory" && item_type.code.present? rescue false
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
    "#{use_of_item.name}" rescue nil
  end

  def department_name
    item_type.department.name rescue nil
  end

  def item_type_name
    item_type.name rescue nil
  end

  def donation_description
    donation.description rescue nil
  end

  #  ========================================
  #  = aliases for default instance methods =
  #  ========================================
  def price; regular_price; end
  def item_name; inventory_number; end
  def item_description; description; end


  #  ====================
  #  = CSV file formats =
  #  ====================

  def csv_deparment_name
    "Donated - #{department_name}"
  end

  comma do
    __use__ :all
  end

  comma :all do
    id 'Id'
    inventory_number 'Item Name'
    department_name
    description 'Item Description'
    regular_price
    item_type_name 'Item Type'
    date_received
    date_sold
    in_stock
    donated
    donation_description 'Donation'
    use_of_item_name 'Use of Item'
    rejected
    rejection_reason
  end

  comma :quick_books do
    id 'Id'
    inventory_number 'Item Name'
    department_name
    description 'Item Description'
    regular_price
    __static_column__ 'Item Type' do 'Inventory' end
    __static_column__ 'Income Account' do 'Sales-Donated' end
  end

private
  def inventory_number_generator
    same_day_items = Item.inventoried.where(item_type_id: item_type_id).where(date_received: date_received).to_a
    same_day_items.delete(self)
    item_type_day_count = same_day_items.length + 1
    date_string = date_received.strftime("%m%d%Y")
    "#{date_string}-#{item_type.code}#{item_type_day_count}"
  end

  def creating_new_item_type?
    new_item_type_department_id.present?
  end
end
