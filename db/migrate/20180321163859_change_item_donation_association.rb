class ChangeItemDonationAssociation < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :pickup_id, :donation_id
  end
end
