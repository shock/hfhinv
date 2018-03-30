ActiveAdmin.register_page "Preview Inventory Export" do
  menu false
  content do
    panel "Filter" do
      render partial: 'admin/export_inventory', locals: {preview: preview || nil}
    end
  end
end
