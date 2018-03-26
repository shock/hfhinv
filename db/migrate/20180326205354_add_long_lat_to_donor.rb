class AddLongLatToDonor < ActiveRecord::Migration[5.1]
  def change
    add_column :donors, :longitude, :float
    add_column :donors, :latitude, :float
  end
end
