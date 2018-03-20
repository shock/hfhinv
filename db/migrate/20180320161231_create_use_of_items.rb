class CreateUseOfItems < ActiveRecord::Migration[5.1]
  def change
    create_table :use_of_items do |t|
      t.string :name

      t.timestamps
    end
  end
end
