ActiveAdmin.register Department do
  menu parent: 'Admin'
  config.batch_actions = false if Rails.env.production?
  config.sort_order = 'name_asc'

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
    column :name
    actions
  end

  show do
    panel "#{department.name} Item Types" do
      scope = department.item_types.order(name: :asc)
      table_for scope do
        column :name
      end
      div class: 'action_items' do
        span class: 'action_item' do
          link_to "Create new #{department.name} Item Type", new_admin_item_type_path(item_type:{department_id: department.id}),
            class: 'default_button'
        end
      end
    end

  end
end
