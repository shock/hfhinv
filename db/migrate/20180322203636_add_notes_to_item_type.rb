class AddNotesToItemType < ActiveRecord::Migration[5.1]
  def change
    add_column :item_types, :notes, :string
  end
end
