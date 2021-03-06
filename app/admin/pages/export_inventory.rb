ActiveAdmin.register_page "Export Inventory CSV" do
  menu parent: 'Items'
  content do
    panel "Filter" do
      preview = params[:preview]
      render partial: 'admin/export_inventory', locals: {preview: preview || nil}
    end
  end
end
