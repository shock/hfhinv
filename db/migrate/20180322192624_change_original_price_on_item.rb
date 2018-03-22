class ChangeOriginalPriceOnItem < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :original_price, :set_price
  end
end
