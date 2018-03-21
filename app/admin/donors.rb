ActiveAdmin.register Donor do
  actions :all, :except => [:destroy] if Rails.env.production?

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

  index do
    selectable_column
    id_column

    column :first_name
    column :last_name
    column :full_address
    column :city
    column :zip
    column :phone
    column :phone2
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


  end

end
