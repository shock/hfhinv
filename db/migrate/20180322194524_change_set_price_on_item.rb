class ChangeSetPriceOnItem < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :set_price, :regular_price
  end
end
