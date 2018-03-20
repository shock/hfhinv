class FixItemPickupId < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :pickup_id
    add_column :items, :pickup_id, :integer
  end
end
