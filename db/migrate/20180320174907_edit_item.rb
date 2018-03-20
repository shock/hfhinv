class EditItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :expected
    remove_column :items, :dropoff_id
  end
end
