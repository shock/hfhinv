ActiveAdmin.register Pickup do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #

  permit_params :date_of_contact, :info_collected_by, :pickup_date, :call_first, :email_receipt, :special_instructions, :donor_id

  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  before_action :new_pickup_defaults, only: [:new]

  controller do
    def new_pickup_defaults
      @pickup = Pickup.new
      @pickup.date_of_contact = Date.today
      @pickup.pickup_date = Date.today
    end
  end

  form do |f|

    f.inputs 'Details' do
      f.input :donor, collection: options_for_select(Donor.all.map{|d| [d.full_name, d.id]})
      # f.select :donor, collection: Donor.all
      f.input :date_of_contact
      f.input :info_collected_by
      f.input :pickup_date
      f.input :call_first
      f.input :email_receipt
      f.input :special_instructions
    end
    f.actions :submit, :cancel

  end

end

