module DonationsHelper

  def donations_collection(item=nil)
    collection = Donation.all.map{|d| ["#{d.description}", d.id]}
    output = if item.present?
      options_for_select(collection, item.donation_id)
    else
      options_for_select(collection)
    end
    output.html_safe
  end

  def admin_donation_link(donation)
    output = ""
    if donation.present?
      output << link_to(donation.description, admin_donation_path(donation))
    end
    output.html_safe
  end
end
