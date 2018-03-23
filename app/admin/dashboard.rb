ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end

    panel "Pickups today" do
      scope = Donation.pickups.today.include_donor_and_items.ordered_by_zip
      table_for scope do
        column :name do |donation| donation.donor.full_name; end
        column :phone do |donation| donation.donor.phone_numbers; end
        column :address do |donation| donation.donor.address; end
        column :city do |donation| donation.donor.city; end
        column :zip do |donation| donation.donor.zip; end
        column :items do |donation|
          ul class: 'items-list' do
            donation.items.each do |item|
              li do
                "#{item.item_type.description}"
              end
            end
          end
        end
        column :actions do |donation|
          output = []
          output << link_to("View", admin_donation_path(donation))
          output.join(" ").html_safe
        end

      end
    end

  end # content
end
