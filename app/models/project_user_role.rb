class ProjectUserRole < ActiveRecord::Base
  belongs_to :project_user
  belongs_to :project_role
end
