ActiveAdmin.register ItemType do
  config.batch_actions = false if Rails.env.production?
  menu parent: 'Admin'
  config.sort_order = 'departments.name_asc'

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

    def scoped_collection
      super.joins(:department)
    end

  end

  index do
    selectable_column
    id_column unless Rails.env.production?
    column :name do |item_type| link_to(item_type.name, admin_item_type_path(item_type)); end
    column :code
    column :notes
    column :department, sortable: 'departments.name'
    actions name: 'Actions', defaults: false do |item_type|
      output = []
      output << link_to("View", admin_item_type_path(item_type))
      output << link_to("Edit", edit_admin_item_type_path(item_type))
      unless item_type.items.count > 0
        output << link_to("Delete", admin_item_type_path(item_type), method: :delete,
          data: {confirm: "Are you sure you want to delete #{item_type.name}?"})
      end
      output.join(' ').html_safe
    end
  end


  show do
    attributes_table do
      row :name
      row :department do |item_type| item_type.department.name end
    end
  end

  filter :department
  filter :code
  filter :notes

end
