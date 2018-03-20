class ChangePickupDefaults < ActiveRecord::Migration[5.1]
  def change
    change_column :pickups, :call_first, :boolean, default: false
    change_column :pickups, :email_receipt, :boolean, default: false
  end
end
