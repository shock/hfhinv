class Donor < ApplicationRecord
  include FormattingHelper

  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.full_address_present? and obj.full_address_changed? }

  #  ====================
  #  = AR Accosciations =
  #  ====================
  has_many :donations, dependent: :destroy

  #  ==================
  #  = AR Validations =
  #  ==================
  PHONE_REGEX = /\A((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,5})|(\(?\d{2,6}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}\Z/
  EMAIL_REGEX = %r{\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\Z}i

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 1 }
  validates :zip, format: { with: ZipCode::ZIP_REGEX }, allow_blank: false
  validates :phone, format: { with: PHONE_REGEX, message: "is not a valid phone number, must be 10 digits" }, allow_blank: false
  validates :phone2, format: { with: PHONE_REGEX, message: "is not a valid phone number, must be 10 digits" }, allow_blank: true

  #  ================
  #  = AR Callbacks =
  #  ================
  before_save :normalize_attributes
  def normalize_attributes
    self.phone = self.phone.gsub(/[^\d]/, '')
    self.address && self.address = self.address.titleize
    self.address2 && self.address2 = self.address2.titleize
  end
  private :normalize_attributes

  #  =============
  #  = AR Scopes =
  #  =============

  scope :alpha_by_last_name, -> { order(last_name: :asc) }

  #  ====================
  #  = Instance Methods =
  #  ====================
  def full_name
    "#{first_name} #{last_name}"
  end

  def street_address
    "#{address} #{address2}"
  end

  def city_state
    "#{city}, #{state}"
  end

  def full_address
    "#{address}, #{city}, #{state} #{zip}"
  end

  def formatted_phone
    format_phone_number(phone) rescue nil
  end

  def formatted_phone2
    format_phone_number(phone2) rescue nil
  end

  def phone_numbers
    unless phone2.present?
      formatted_phone
    else
      "#{formatted_phone}, #{formatted_phone2}"
    end
  end

  def description
    desc = "#{full_name}"
    desc << " (#{email})" if email.present?
    desc
  end

  def html_encoded_address
    "#{full_address}".gsub(' ', '+')
  end

  def google_maps_url
    "https://www.google.com/maps/place/#{html_encoded_address}"
  end

  def full_address_present?
    address.present? && city.present? && state.present? && zip.present?
  end

  def full_address_changed?
    address_changed? || city_changed? || state_changed? || zip_changed?
  end

end
