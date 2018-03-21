class Donation < ApplicationRecord

  #  ====================
  #  = AR Asccociations =
  #  ====================
  belongs_to :donor
  has_many :items

  #  ==================
  #  = AR Validations =
  #  ==================
  validates :donor_id, presence: true
  validates :info_collected_by, presence: true
  validates :date_of_contact, presence: true
  validates :pickup_date, presence: { message: 'Required for pickups' }, if: :pickup


  #  ====================
  #  = Instance Methods =
  #  ====================
  def description
    "#{donor.full_name} - #{pickup_date}"
  end
end
