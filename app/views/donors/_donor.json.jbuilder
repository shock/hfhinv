json.extract! donor, :id, :first_name, :last_name, :address, :address2, :city, :state, :zip, :phone, :phone2, :email, :created_at, :updated_at
json.url donor_url(donor, format: :json)
