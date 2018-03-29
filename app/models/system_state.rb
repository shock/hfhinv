class SystemState < ApplicationRecord
  include SerialData

  serial_attr :last_inventory_export_datetime, type: DateTime
  serial_attr :last_inventory_export_item_id

  self.serial_data_options = {auto_save: true}

  # You can call any reader/writer method for defined serial_attr attributes
  # directly on SystemState.  Writer methods will persists the record immediately
  def self.singular_instance
    where(name: 'state').first rescue nil
  rescue
    raise "The database must have a table 'system_states' with a row with name: 'state'"
  end

  def self.method_missing(method, *args)
    if self.method_defined?(method.to_sym)
      instance = self.singular_instance
      if args.any?
        instance.send(method, args.first)
      else
        instance.send(method)
      end
    else
      super
    end
  end

end
