class Donor < ApplicationRecord
  include FormattingHelper

  PHONE_REGEX = /\A((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,5})|(\(?\d{2,6}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}\Z/
  EMAIL_REGEX = %r{\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\Z}i
  ZIP_REGEX = /\A\d{5}(?:-\d{4})?\Z/
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 1 }
  validates :zip, format: { with: ZIP_REGEX }, allow_blank: false
  validates :phone, format: { with: PHONE_REGEX, message: "is not a valid phone number, must be 10 digits" }, allow_blank: false
  validates :phone2, format: { with: PHONE_REGEX, message: "is not a valid phone number, must be 10 digits" }, allow_blank: true

  before_save :normalize_attributes
  def normalize_attributes
    self.phone = format_phone_number(self.phone)
    self.address && self.address = self.address.titleize
    self.address2 && self.address2 = self.address2.titleize
  end
  private :normalize_attributes

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    "#{address} #{address2}"
  end

  def city_state
    "#{city}, #{state}"
  end

  def phone_numbers
    unless phone2.present?
      phone
    else
      "#{phone}, #{phone2}"
    end
  end

  def name
    desc = "#{full_name}"
    desc << " (#{email})" if email.present?
    desc
  end
end
