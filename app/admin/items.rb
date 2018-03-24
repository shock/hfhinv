ActiveAdmin.register Item do
  config.batch_actions = false if Rails.env.production?
  menu priority: 12
  scope :received
  scope :inventoried
  scope :in_stock
  scope :sold

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :item_type_id, :expected, :donation_id, :use_of_item_id, :regular_price,
    :sale_price, :date_received, :date_sold, :rejected, :rejection_reason, :item_number, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column unless Rails.env.production?
    column :item_type do |item| item.summary_description end
    column :use_of_item do |item|
      item.use_of_item.name rescue nil
    end
    column :regular_price
    # column :sale_price
    column :date_received
    column :in_stock
    column :donation do |item| link_to(item.donation.description, admin_donation_path(item.donation)); end
    column :inventory_number
    actions
  end


  show title: proc{ |item| item.full_description } do
    attributes_table do
      row :donation do |item| link_to(item.donation.description, admin_donation_path(item.donation)) end
      row :item_type do |item| item.summary_description end
      row :description
      row :date_received
      row :use_of_item do |item| item.use_of_item.name rescue nil end
      row :inventory_number
      row :regular_price
      row :sale_price
      row :date_sold
      row :rejected
      row :rejection_reason
    end

    panel "Actions" do
      output = []
      output << link_to("Add Another Item to this Donation", new_admin_item_path(item:{donation_id: item.donation.id}), class: 'default_button')
      output.join(" ").html_safe
    end
    active_admin_comments
  end


  form do |f|

    f.inputs 'Details' do
      f.input :donation, collection: options_for_select(Donation.all.map{|d| ["#{d.description}", d.id]}, item.donation_id)
      item_type_descriptions = []
      Department.all.order(name: :asc).each do |department|
        department.item_types.order(name: :asc).map do |item_type|
          item_type_descriptions << [item_type.description, item_type.id]
        end
      end

      f.input :item_type, collection: options_for_select(item_type_descriptions, item.item_type_id)
      f.input :description
      f.input :date_received, as: :date_picker
      f.input :use_of_item
      f.input :regular_price
      f.input :date_sold, as: :date_picker
      f.input :sale_price
      f.input :rejected, label: 'Rejected at Pickup'
      f.input :rejection_reason
    end
    f.actions

  end

  filter :donation, collection: -> { options_for_select(Donation.all.order(pickup_date: :desc).map{|d| [d.description, d.id]}) }
  filter :item_type, collection: -> { options_for_select(ItemType.all_sorted.map{|i| [i.description, i.id]}) }
  filter :use_of_item
  flag_filter :in_stock
  filter :date_sold
  filter :date_received
  filter :rejected
end
