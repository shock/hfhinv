class AddDonationsCountToDonor < ActiveRecord::Migration[5.1]
  def change
    add_column :donors, :donations_count, :integer, default: 0, null: false
    Donor.find_each do |donor|
      Donor.reset_counters(donor.id, :donations)
    end
  end
end
