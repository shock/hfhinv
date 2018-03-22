class AddCodeToItemType < ActiveRecord::Migration[5.1]
  def change
    add_column :item_types, :code, :string
  end
end
