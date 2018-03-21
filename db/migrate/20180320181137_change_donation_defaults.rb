class ChangePickupDefaults < ActiveRecord::Migration[5.1]
  def change
    change_column :donations, :call_first, :boolean, default: false
    change_column :donations, :email_receipt, :boolean, default: false
  end
end
