class Group < Base
  include ActiveModel::ForbiddenAttributesProtection
  #attr_accessible :name
  has_many :teams
  belongs_to :parent, class_name: Group.name
end
