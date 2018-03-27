class AddItemsCountToDonation < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :items_count, :integer, default:0, null: false
    add_column :item_types, :items_count, :integer, default:0, null: false
    add_column :use_of_items, :items_count, :integer, default:0, null: false
    add_column :departments, :items_count, :integer, default:0, null: false
    Donation.find_each do |obj|
      Donation.reset_counters(obj.id, :items)
    end
    ItemType.find_each do |obj|
      ItemType.reset_counters(obj.id, :items)
    end
    UseOfItem.find_each do |obj|
      UseOfItem.reset_counters(obj.id, :items)
    end
  end
end
