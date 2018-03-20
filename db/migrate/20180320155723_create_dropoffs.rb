class CreateDropoffs < ActiveRecord::Migration[5.1]
  def change
    create_table :dropoffs do |t|
      t.date :date
      t.integer :donor_id

      t.timestamps
    end
  end
end
