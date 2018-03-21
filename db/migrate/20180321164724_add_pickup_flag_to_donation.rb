class AddPickupFlagToDonation < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :pickup, :boolean, default: nil
  end
end
