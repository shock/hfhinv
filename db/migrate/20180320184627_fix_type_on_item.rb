class FixTypeOnItem < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :rejection_resason, :rejection_reason
  end
end
