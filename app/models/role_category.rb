class RoleCategory < ActiveRecord::Base
  #attr_accessible :name

  has_many :roles
end
