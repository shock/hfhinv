class ChangeUseOfItemIdInItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :use_of_item_id
    add_column :items, :use_of_item_id, :integer
  end
end
