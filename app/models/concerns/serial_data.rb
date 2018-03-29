# Helper concern for managing a serialized data column in an ActiveRecord model.  It expects for the model
# to have a string column named `serial_data` of sufficient length to hold the max possible
# serialized JSON data.
#
# Use as follows, in your model after including the SerialData concern
#   serial_attr :attr1 # defines an attribute named :attr1
#   serial_attr :attr2 # defines an attribute named :attr2
#   serial_attr :attr3, :default => '123' # declares a default valut if the attribute is not set
#   serial_attr :attr4, :default => Proc.new {Array.new}, uses a proc at runtime to set a default value


module SerialData
  extend ActiveSupport::Concern

  included do
    cattr_accessor :serial_data_options, :serial_data_attributes
    self.serial_data_options = {}
    self.serial_data_attributes = []

    before_save :process_serial_data_attrs
  end

  module ClassMethods
    def serial_attr(attr_name, options={})
      self.serial_data_attributes |= ["#{attr_name}"]
      attribute attr_name
      reader_method = attr_name
      writer_method = "#{attr_name}="

      define_method(reader_method) do
        if serial_data.has_key?(reader_method)
          value = serial_data.send(reader_method)
          value = case options[:type].to_s
          when "DateTime"
            DateTime.parse(value)
          else
            value
          end
          return value
        else
          default = options[:default]
          default = default.call if default.is_a?(Proc)
          serial_data[attr_name] = default
          return default
        end
      end

      define_method(writer_method) do |value|
        attribute_will_change!(attr_name)
        data = self.serial_data
        data.send(writer_method, value)
        self.serial_data = data
        if self.class.serial_data_options[:auto_save] == true
          process_serial_data_attrs
          self.save!
        end
      end
    end
  end

  #  ====================
  #  = Instance Methods =
  #  ====================

  def serial_data
    @serial_data ||= begin
      HashObj.new(JSON.parse(self[:serial_data] || "{}"))
    rescue JSON::ParserError
      HashObj.new
    end
  end

  def serial_data=(serial_data)
    serial_data = JSON.parse(serial_data) if serial_data.is_a?(String)
    @serial_data = HashObj.new(serial_data)
  end

private

  def process_serial_data_attrs
    serial_data = self.serial_data()
    serial_data.keys.each {|k| serial_data.delete(k) if serial_data[k].nil?}
    serial_data = serial_data.deep_sort if self.class.serial_data_options[:deep_sort]
    self.write_attribute(:serial_data, serial_data.to_json)
    true
  end

end