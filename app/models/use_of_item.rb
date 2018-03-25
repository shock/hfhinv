class UseOfItem < ApplicationRecord
  has_many :items
  USES_OF_ITEM = ["Inventory", "General Stock", "Recycle", "Donate", "Use In Store", "Discard"]

  validates :name, presence: true, uniqueness: true

  def self.uses
    self.all.pluck(:name)
  end

  def self.uses_methods
    uses.map do |name|
      name_underscored(name)
    end
  end

  def self.name_underscored(name)
    name.gsub(/\s+/, '').underscore
  end

  def name_underscored
    self.class.name_underscored(name)
  end

  def method_missing(method, *args)
    if method.to_s.gsub(/\?\Z/, '').in?(self.class.uses_methods)
      if method.to_s =~ /#{name_underscored}\??/
        return true
      else
        return false
      end
    else
      super
    end
  end

end
