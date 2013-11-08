class GroupUser < ActiveRecord::Base
  #attr_accessible :user_id, :group_id
  include ActiveModel::ForbiddenAttributesProtection
  belongs_to :group
  belongs_to :user
end
