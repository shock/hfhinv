class PickupsController < InheritedResources::Base

  private

    def pickup_params
      params.require(:pickup).permit(:date_of_contact, :info_collected_by, :pickup_date, :call_first, :email_receipt, :special_instructions, :donor_id)
    end
end

