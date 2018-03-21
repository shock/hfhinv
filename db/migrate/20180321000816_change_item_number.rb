class ChangeItemNumber < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :item_number, :inventory_number
  end
end
