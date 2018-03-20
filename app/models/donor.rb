class Donor < ApplicationRecord

  def full_name
    "#{first_name} #{last_name} (#{email})"
  end
end
