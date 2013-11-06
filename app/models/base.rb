class Base < ActiveRecord::Base
  extend ActiveModel::Translation

  self.abstract_class = true

  def human_attribute_value(name)
    !(v = send(name) rescue nil).nil? && self.class.name.underscore.send(name) rescue nil && !(l = s.detect { |p| p.last == v }).nil? ? l.first : v
  end

  def translate(name)
    send("#{name.to_s}_#{I18n.locale.to_s}") rescue send(name)
  end
  alias :t :translate
end
