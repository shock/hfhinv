ActiveAdmin.register Donation do
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

  before_action :new_donation_defaults, only: [:new]

  controller do
    def new_donation_defaults
      @donation = Donation.new
      @donation.date_of_contact = Date.today
      @donation.pickup_date = Date.today
    end
  end

  index do
    selectable_column
    id_column
    column :donor
    column :pickup
    column :pickup_date
    column :info_collected_by
  end

  show do
    attributes_table do
      row :donor do |donation| link_to(donation.donor.summary_description, admin_donor_path(donation.donor)) end
      row :date_of_contact
      row :info_collected_by
      row :pickup_date
      row :call_first
      row :email_receipt
      row :special_instructions
    end

    panel "Items" do
      scope = donation.items.order(created_at: :asc)
      table_for scope do
        column :item_type do |item|
          link_to item.description, admin_item_path(item)
        end
        column :date_received
        column :use_of_item
        column :original_price
        column :sale_price
        column :date_sold
        column :rejected
        column :actions do |item|
          output = []
          output << link_to("Edit", edit_admin_item_path(item))
          output << link_to('Destroy', admin_item_path(item),
                                  method: :delete,
                                  data: { confirm: 'Are you sure?' })
          output.join(" ").html_safe
        end
      end
    end

  end

  form do |f|

    f.inputs 'Details' do
      f.input :donor, collection: options_for_select(Donor.all.map{|d| [d.full_name, d.id]})
      # f.select :donor, collection: Donor.all
      f.input :date_of_contact
      f.input :info_collected_by
      f.input :pickup
      f.input :pickup_date
      f.input :call_first
      f.input :email_receipt
      f.input :special_instructions
    end
    f.actions :submit, :cancel

  end

end

