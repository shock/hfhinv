ActiveAdmin.register ZipCode do
  config.batch_actions = false if Rails.env.production?
  menu parent: 'Admin'
  config.sort_order = 'zipcode_asc'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :zipcode
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # index do
  #   selectable_column
  #   id_column unless Rails.env.production?
  #   column :zipcode
  #   actions
  # end

  show title: :zipcode do
    attributes_table do
      row :zipcode
      row :city
      row :state
      row :county
      row :longitude
      row :latitude
      row :timezone
    end
  end

  form do |f|
    f.inputs 'Details' do
      f.input :zipcode
    end
    f.actions
  end



  filter :zipcode
  filter :city
  filter :state
  filter :county

end
