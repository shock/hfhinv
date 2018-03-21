class ChangePickupToDonation < ActiveRecord::Migration[5.1]
  def change
    rename_table :pickups, :donations
  end
end
