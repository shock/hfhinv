class DonationsController < InheritedResources::Base

  private

    def pickup_params
      params.require(:donation).permit(:date_of_contact, :info_collected_by, :pickup_date, :call_first, :email_receipt, :special_instructions, :donor_id)
    end
end

