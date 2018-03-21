class Item < ApplicationRecord
  belongs_to :pickup
  belongs_to :item_type, optional: true
  belongs_to :use_of_item, optional: true

  #  ===============
  #  = AR Callback =
  #  ===============
  before_save :check_update_inventory_number

  def check_update_inventory_number
    if item_type.present? && inventory_number.blank? && date_received.present?
      if use_of_item_id_changed? && use_of_item.name == "Inventory"
        self.inventory_number = inventory_number_generator
      end
    end
  end
  private :check_update_inventory_number

  def inventory_number_generator
    type_count = Item.where(item_type_id: item_type_id).where(date_received: date_received).count
    type_count += 1
    date_string = date_received.strftime("%m%d%Y")
    "#{date_string}-#{item_type.name}#{type_count}"
  end


  def description
    "#{item_type.department.name} - #{item_type.name}"
  end


end
