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

  #  =============
  #  = AR Scopes =
  #  =============
  scope :past, -> { where("pickup_date < ?", Date.today) }
  scope :today, -> { where("pickup_date = ?", Date.today) }
  scope :future, -> { where("pickup_date > ?", Date.today) }
  scope :pickups, -> { where(pickup: true) }
  scope :received, -> { joins(:items).where.not(items: {date_received: nil})}
  scope :pickups_received, -> { pickups.received }
  scope :include_donor_and_items, -> { includes([:donor, {items: {item_type: :department}}]) }
  scope :ordered_by_zip, -> { joins(:donor).merge(Donor.order(zip: :asc)) }
  #  ====================
  #  = Instance Methods =
  #  ====================
  def description
    "#{pickup_date} - #{donor.full_name}"
  end

end
