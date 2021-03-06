ActiveAdmin.register Donation do
  actions :all, :except => [:destroy] if Rails.env.production?
  config.batch_actions = false if Rails.env.production?
  menu priority: 11
  config.sort_order = 'pickup_date_desc'

  scope :all, default: true
  scope :today
  scope :future
  scope :past
  scope :pickups
  scope :received

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #

  permit_params :date_of_contact, :info_collected_by, :pickup_date, :call_first, :email_receipt, :special_instructions, :donor_id, :pickup

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
      if params[:donation] && (donor_id = params[:donation][:donor_id])
        @donation.donor_id = donor_id
      end
      @donation.date_of_contact = Time.current.to_date
      @donation.pickup_date = Time.current.to_date
    end
  end

  index do
    selectable_column
    id_column unless Rails.env.production?
    column :donor
    column :pickup
    column :pickup_date
    column 'Items', :items_count
    actions name: 'Actions', defaults: false do |donation|
      output = []
      output << link_to("View", admin_donation_path(donation))
      output << link_to("Edit", edit_admin_donation_path(donation))
      output << link_to("Delete", admin_donation_path(donation), method: :delete,
        data: {confirm: "Are you sure you want to delete #{donation.description}?"})
      output << link_to("View on Map", donation.donor.google_maps_url, target: "_blank")
      output.join(' ').html_safe
    end

  end

  show title: proc{ |donation| donation.description} do
    attributes_table do
      row :donor do |donation| link_to(donation.donor.description, admin_donor_path(donation.donor)) end
      row :location do |donation|
        donor = donation.donor
        output = []
        output << donor.full_address
        output << link_to("View on Map", donor.google_maps_url, target: "_blank", class: "small_button")
        output.join("&nbsp;&nbsp;&nbsp;").html_safe
      end
      row :date_of_contact
      row :info_collected_by
      row :pickup
      row :pickup_date
      row :call_first
      row :email_receipt
      row :special_instructions
    end

    panel "Items" do
      scope = donation.items.order(created_at: :asc)
      table_for scope do
        column :item_type do |item|
          link_to item.summary_description, admin_item_path(item)
        end
        column :date_received
        column :use_of_item
        column :regular_price
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
      div class: 'action_items' do
        span class: 'action_item' do
          link_to "Add Another Item", new_admin_item_path(item:{donation_id: donation.id}), class: 'default_button'
        end
      end

    end

  end

  form do |f|
    f.inputs 'Details' do
      f.input :donor, collection: options_for_select(Donor.all.map{|d| [d.full_name, d.id]}, donation.donor_id)
      # f.select :donor, collection: Donor.all
      f.input :date_of_contact, as: :date_picker
      f.input :info_collected_by, input_html: {placeholder: "Initials or Name"}
      f.input :pickup
      f.input :pickup_date, as: :date_picker
      f.input :call_first
      f.input :email_receipt
      f.input :special_instructions
    end
    f.actions
  end

  filter :donor
  filter :items
  filter :date_of_contact
  filter :info_collected_by
  filter :pickup_date
  filter :pickup
end

