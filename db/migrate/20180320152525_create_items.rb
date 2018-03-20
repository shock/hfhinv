class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.integer :item_type_id
      t.string :expected
      t.boolean :pickup_id
      t.integer :dropoff_id
      t.string :use_of_item_id
      t.decimal :original_price, :precision => 8, :scale => 2
      t.decimal :sale_price, :precision => 8, :scale => 2
      t.date :date_received
      t.date :date_sold

      t.timestamps
    end
  end
end
