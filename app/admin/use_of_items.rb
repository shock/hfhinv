ActiveAdmin.register UseOfItem do
  config.batch_actions = false if Rails.env.production?
  menu parent: 'Admin'

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
    actions defaults: false do |item|
      output = []
      output << link_to("View", admin_item_path(item))
      output << link_to("Edit", edit_admin_item_path(item))
      output << link_to("Delete", admin_item_path(item), method: :delete,
        data: {confirm: "Are you absolutely sure you want to delete #{item.name}? If any items exist with this use type, you will corrupt the database!!"})
      output.join(' ').html_safe
    end
  end

end
