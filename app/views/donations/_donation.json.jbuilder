json.extract! donation, :id, :date_of_contact, :info_collected_by, :donation_date, :call_first, :email_receipt, :special_instructions, :donor_id, :created_at, :updated_at
json.url donation_url(donation, format: :json)
