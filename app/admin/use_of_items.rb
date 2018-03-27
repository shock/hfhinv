ActiveAdmin.register UseOfItem do
  config.batch_actions = false if Rails.env.production?
  menu parent: 'Admin'
  config.sort_order = 'name_asc'
  config.filters = false

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name
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
    column :name
    column 'Items', :items_count
    actions name: 'Actions', defaults: false do |use_of_item|
      output = []
      output << link_to("View", admin_use_of_item_path(use_of_item))
      output << link_to("Edit", edit_admin_use_of_item_path(use_of_item))
      unless use_of_item.items.count > 0
        output << link_to("Delete", admin_use_of_item_path(use_of_item), method: :delete,
          data: {confirm: "Are you sure you want to delete #{use_of_item.name}?"})
      end
      output.join(' ').html_safe
    end
  end

end
