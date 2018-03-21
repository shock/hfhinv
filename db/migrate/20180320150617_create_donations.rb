class CreateDonationss < ActiveRecord::Migration[5.1]
  def change
    create_table :donations do |t|
      t.date :date_of_contact
      t.string :info_collected_by
      t.date :pickup_date
      t.boolean :call_first
      t.boolean :email_receipt
      t.text :special_instructions
      t.integer :donor_id

      t.timestamps
    end
  end
end
