ActiveAdmin.register Item do
  config.batch_actions = false if Rails.env.production?
  menu priority: 12
  scope :all, default: true
  scope :received
  scope :inventoried
  scope :in_stock
  # scope :donated
  scope :sold
  config.sort_order = 'departments.name_asc'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :item_type_id, :expected, :donation_id, :use_of_item_id, :regular_price,
    :sale_price, :date_received, :date_sold, :rejected, :rejection_reason, :item_number, :description,
    :new_item_type_department_id, :new_item_type_name, :new_item_type_code, :new_item_type_notes,
    :scope, :format, :preview
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  before_action :new_item_defaults, only: [:new]

  collection_action :export_items, method: :post do
    scope = params[:scope].to_sym
    format = params[:format].to_sym
    items = Item.send(scope)
    csv = items.to_comma(format)
    if params[:commit] == "Preview"
      render partial: 'admin/export_inventory', locals: {preview: csv}
    else
      filename = "inventory_export_#{Time.now.to_i}.csv"
      set_csv_headers(filename)
      send_data(csv, :type => 'text/csv; charset=utf-8; header=present',
        :filename => filename)
    end
  end

  controller do
    def new_item_defaults
      @item = Item.new
      donation = Donation.find(params[:item][:donation_id]) rescue nil
      @item.donation = donation
      @item.donated = true if donation
      @item.date_received = Time.current.to_date unless donation.pickup? rescue nil
    end

    def scoped_collection
      super.includes({item_type: :department}).joins({item_type: :department})
    end
  end

  index do
    selectable_column
    id_column
    column :department, sortable: 'departments.name'
    column :item_type, sortable: 'item_types.name'
    # column :item_type do |item| item.summary_description end
    column :use_of_item do |item|
      item.use_of_item.name rescue nil
    end
    column :price, sortable: 'regular_price' do |item| item.regular_price; end
    # column :sale_price
    column :date_received
    column :in_stock
    column :donation do |item| admin_donation_link(item.donation); end
    column :inventory_number
    actions name: 'Actions'
  end


  show title: proc{ |item| item.full_description } do
    attributes_table do
      row :donation do |item| admin_donation_link(item.donation) end
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
      if item.donation_id.present?
        output << link_to("Add Another Item to Donation: #{item.donation.description}", new_admin_item_path(item:{donation_id: item.donation.id}), class: 'default_button')
      else
        output << link_to("Create Another Item", new_admin_item_path, class: 'default_button')
      end
      output.join(" ").html_safe
    end
    active_admin_comments
  end


  form do |f|

    def options_for_item_type_select(current_item_type)
      item_type_descriptions = []
      Department.all.order(name: :asc).each do |department|
        department.item_types.order(name: :asc).map do |item_type|
          item_type_descriptions << [item_type.description, item_type.id, item_type.notes]
        end
        item_type_descriptions << ["#{department.name} - Other", "-#{department.id}", ""]
      end
      options = item_type_descriptions.map do |e|
        selected = (e[1] == (current_item_type.id rescue nil))
        "<option value=\"#{e[1]}\" #{selected ? 'selected="selected"' : ''} data-notes='#{e[2].gsub("'", "\'")}'>#{e[0]}</option>"
      end
      options = options.join("\n").html_safe
      options
    end

    f.inputs 'Details' do
      f.semantic_errors # shows errors on :base
      f.input :donation, collection: donations_collection(item)
      f.input :item_type, class: 'select2', collection: options_for_item_type_select(item.item_type)
      div class: 'form-indented new-item-form hidden' do
        output = "This will create a new Item Type in the "
        output << '<a href="javascript:void" class="new-item-department-name"></a>'
        output << " department.  Please be sure there is not an existing "
        output << '<a href="javascript:void" class="new-item-department-name"></a> type that could be used first.'
        f.inputs output.html_safe do
          f.input :new_item_type_department_id, as: :hidden
          f.input :new_item_type_name, as: :string, input_html: {placeholder: 'Enter a brief name for this type of item'}
          f.input :new_item_type_code, as: :string, input_html: {placeholder: 'Enter code for inventory number'}
          f.input :new_item_type_notes, as: :string, input_html: {placeholder: 'Enter notes on how to describe these types of items'}
        end
      end
      f.input :description
      f.input :date_received, as: :string, input_html: { class: "datepicker" }
      f.input :use_of_item
      f.input :regular_price
      f.input :date_sold, as: :string, input_html: { class: "datepicker" }
      f.input :sale_price
      f.input :rejected, label: 'Rejected at Pickup'
      f.input :rejection_reason
    end
    f.actions

  end

  filter :donation, collection: -> {
    options_for_select(Donation.all.order(pickup_date: :desc).map{|d| [d.description, d.id]})
  }
  filter :item_type, collection: -> {
    options_for_select(ItemType.all_sorted.map{|i| [i.description, i.id]})
  }
  filter :department, collection: -> {
    options_for_select(Department.all.order(:name).map{|d| [d.name, d.id]})
  }
  filter :use_of_item
  flag_filter :in_stock
  flag_filter :donated
  filter :inventory_number
  filter :date_sold
  filter :date_received
  filter :rejected
  filter :description
end
