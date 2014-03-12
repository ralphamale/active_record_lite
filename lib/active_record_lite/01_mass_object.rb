require_relative '00_attr_accessor_object.rb'

class MassObject < AttrAccessorObject
  def self.my_attr_accessible(*new_attributes)
    self.attributes.concat(new_attributes)
  end

  def self.attributes
    raise "must not call #attributes on MassObject directly" if self.name == "MassObject"
    @attributes ||= []
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      raise "mass assignment to unregistered attribute '#{attr_name}'" unless self.class.attributes.include?(attr_name.to_sym)
      self.send("#{attr_name.to_sym}=", value)
    end
  end
end
