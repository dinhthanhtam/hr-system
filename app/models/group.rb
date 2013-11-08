class Group < Base
  include ActiveModel::ForbiddenAttributesProtection
  #attr_accessible :name
  has_many :teams
end
