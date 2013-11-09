class Favourite < Base
  include ActiveModel::ForbiddenAttributesProtection
  
  validates_uniqueness_of :user_id, scope: [:report_id, :user_id]
  
  belongs_to :user
end
