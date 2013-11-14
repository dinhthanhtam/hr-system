class Team < Base
  #attr_accessible :name, :group_id
  scope :in_groups, ->(group_ids) { where("group_id in (?)", group_ids) unless group_ids.nil? }

  belongs_to :group
  has_many :users
end
