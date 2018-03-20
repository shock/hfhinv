class DefaultRejectedOnItem < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :rejected, :boolean, default: false
  end
end
