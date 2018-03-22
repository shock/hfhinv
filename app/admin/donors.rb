ActiveAdmin.register Donor do

  actions :all, :except => [:destroy] if Rails.env.production?
  config.batch_actions = false if Rails.env.production?
  config.sort_order = 'last_name_asc'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :first_name, :last_name, :address, :address2, :city, :state, :zip,
    :phone, :phone2, :email
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  controller do
    def find_resource
      donor = scoped_collection.find(params[:id])
      donor.phone = donor.formatted_phone
      donor.phone2 = donor.formatted_phone2
      donor
    end
  end



  index do
    selectable_column
    id_column

    column :first do |donor| link_to "#{donor.first_name}", admin_donor_path(donor) end
    column :last_name do |donor| link_to "#{donor.last_name}", admin_donor_path(donor) end
    column :full_address
    column :city
    column :zip
    column :phone do |donor| format_phone_number(donor.phone) rescue nil end
    column :phone2 do |donor| format_phone_number(donor.phone2) rescue nil end
    actions
  end

  show do
    attributes_table do
      row :full_name
      row :full_address
      row :city_state
      row :zip
      row :phone_numbers
      row :email
    end

    panel "Donations (Pickups)" do
      scope = donor.donations.order(pickup_date: :desc)
      table_for scope do
        column :date_of_contact do |donation| link_to(normal_date(donation.date_of_contact), admin_donation_path(donation)); end
        # column :info_collected_by
        column :pickup
        column :pickup_date
        column :day do |donation| dotw(donation.pickup_date); end
        column :actions do |donation|
          output = []
          output << link_to("View", admin_donation_path(donation))
          output << link_to("Edit", edit_admin_donation_path(donation))
          output << link_to('Destroy', admin_donation_path(donation),
                                  method: :delete,
                                  data: { confirm: 'Are you sure?' })
          output.join(" ").html_safe
        end
      end
      div class: 'action_items' do
        span class: 'action_item' do
          link_to "Create new Donation/Pickup", new_admin_donation_path(donor:{donor_id: donor.id}),
            class: 'default_button'
        end
      end
    end
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :phone
  filter :phone2

end
