# Convenience extension to filter on FlagShizTzu flags in the AA side_bar
module HfhInv
  module ActiveAdmin
    module DSL

      # used like a standard ActiveAdmin::Resource `filter` DSL call, but for FlagShizTzu flags
      # A corresponding `flag_ransacker` call must be made on the model, which must include
      # the HasFlags module defined in app/concerns/models/has_flags.rb
      def flag_filter(flag, flag_col: 'flags')
        resource = @config.resource_name.name.constantize
        resource.flag_ransacker(flag, flag_col) # call the ransacker builder on the model
        flag = flag.to_s
        filter :"#{flag}_flag_equals", as: :boolean, label: flag.gsub('_', ' ').titleize
      end
    end
  end
end

ActiveAdmin::ResourceDSL.send :include, HfhInv::ActiveAdmin::DSL
