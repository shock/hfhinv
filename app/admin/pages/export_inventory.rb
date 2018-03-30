ActiveAdmin.register_page "Export Inventory" do
  menu parent: 'Items'
  content do
    panel "Filter" do
      render partial: 'admin/export_inventory'
    end
  end
end
