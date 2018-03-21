class FixItemDonationId < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :donation_id
    add_column :items, :donation_id, :integer
  end
end
