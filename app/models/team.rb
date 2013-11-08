class Team < Base
  #attr_accessible :name, :group_id

  belongs_to :group
end
