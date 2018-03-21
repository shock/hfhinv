class Donor < ApplicationRecord

  def full_name
    "#{first_name} #{last_name} (#{email})"
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

  def summary_description
    "#{first_name} #{last_name} (#{email})"
  end
end
