class AddItemNumberToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :item_number, :string
  end
end
