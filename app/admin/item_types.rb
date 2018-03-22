ActiveAdmin.register ItemType do
  config.batch_actions = false if Rails.env.production?
  menu parent: 'Admin'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :department_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  before_action :new_item_type_defaults, only: [:new]

  controller do
    def new_item_type_defaults
      @item_type = ItemType.new
      if params[:item_type] && (department_id = params[:item_type][:department_id])
        @item_type.department_id = department_id
      end
    end
  end



  show do
    attributes_table do
      row :name
      row :department do |item_type| item_type.department.name end
    end
  end

end
