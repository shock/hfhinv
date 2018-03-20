ActiveAdmin.register Item do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :item_type_id, :expected, :pickup_id, :use_of_item_id, :original_price,
    :sale_price, :date_received, :date_sold, :rejected, :rejection_reason
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  show do
    attributes_table do
      row :item_type
      row :pickup do |item| item.pickup.description end
      row :date_received
      row :use_of_item
      row :original_price
      row :sale_price
      row :date_sold
      row :rejected
      row :rejection_reason
    #     photogs = User.find(booking.rejected)
    #     output = []
    #     photogs.each do |p|
    #       output << "<a href='#{admin_user_path(p)}'>#{p.full_name}</a>"
    #     end
    #     output.join(", ").html_safe
    #   end
    #   row 'Requested Photogs' do |booking|
    #     if booking.event && (p = booking.event.booked_photographer)
    #       "<a href='#{admin_user_path(p)}'>#{p.full_name}</a>".html_safe
    #     else
    #       "None"
    #     end
    #   end
    #   row 'Pre-selected Photog' do |booking|
    #     if p = booking.preselected_phgr
    #       "<a href='#{admin_user_path(p)}'>#{p.full_name}</a>".html_safe
    #     else
    #       "None"
    #     end
    #   end
    # end

    # if booking.event
    #   panel "Invitations" do
    #     scope = Invitation.includes([:event, :user]).joins(:event)
    #     scope = scope.where(event: {id: booking.event_id}).order(created_at: :desc)
    #     table_for scope do
    #       column 'ID' do |invitation|
    #         link_to invitation.id, admin_invitation_path(invitation)
    #       end
    #       column 'Photographer', :user
    #       column :event
    #       column 'Braintree Transaction' do |invitation|
    #         braintree_transaction_link(invitation.braintree_transaction_id)
    #       end
    #       column :created_at
    #       column :accepted_at
    #       column :declined_at
    #     end
    #   end
    # else
    #   panel "No Invitations Sent" do
    #   end
    end

    active_admin_comments
  end


  form do |f|

    f.inputs 'Details' do
      f.input :pickup, collection: options_for_select(Pickup.all.map{|p| ["#{p.description}", p.id]}, item.pickup_id)
      f.input :item_type
      f.input :date_received, as: :date_picker
      f.input :use_of_item
      f.input :original_price
      f.input :sale_price
      f.input :date_sold, as: :date_picker
      f.input :rejected
      f.input :rejection_reason
    end
    f.actions :submit, :cancel

  end



end
