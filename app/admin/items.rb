ActiveAdmin.register Item do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :item_type_id, :expected, :donation_id, :use_of_item_id, :original_price,
    :sale_price, :date_received, :date_sold, :rejected, :rejection_reason, :item_number
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
    id_column
    column :item_type do |item| item.description end
    column :use_of_item
    column :original_price
    column :sale_price
    column :date_received
    column :rejected
    column :donation do |item| item.donation.description end
    column :inventory_number
    actions
  end


  show do
    attributes_table do
      row :item_type do |item| item.description end
      row :donation do |item| item.donation.description end
      row :date_received
      row :use_of_item do |item| item.use_of_item.name rescue nil end
      row :inventory_number
      row :original_price
      row :sale_price
      row :date_sold
      row :rejected
      row :rejection_reason
    end

    panel "Actions" do
      output = []
      output << link_to("Add Another Item to this Donation", "#")
      output.join(" ").html_safe
    end
    active_admin_comments
  end


  form do |f|

    f.inputs 'Details' do
      f.input :donation, collection: options_for_select(Donation.all.map{|d| ["#{d.description}", d.id]}, item.donation_id)
      item_type_descriptions = []
      Department.all.order(name: :asc).each do |department|
        department.item_types.map do |item_type|
          item_type_descriptions << [item_type.description, item_type.id]
        end
      end

      f.input :item_type, collection: options_for_select(item_type_descriptions, item.item_type_id)
      f.input :date_received, as: :date_picker
      f.input :use_of_item
      f.input :inventory_number
      f.input :original_price
      f.input :sale_price
      f.input :date_sold, as: :date_picker
      f.input :rejected
      f.input :rejection_reason
    end
    f.actions :submit, :cancel

  end



end
