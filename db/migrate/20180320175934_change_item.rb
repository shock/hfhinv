class ChangeItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :rejected, :boolean
    add_column :items, :rejection_resason, :string
  end
end
