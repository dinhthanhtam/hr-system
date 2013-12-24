class ProjectUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :project_user_roles, dependent: :destroy
  has_many :project_roles, through: :project_user_roles, source: :project_role
  accepts_nested_attributes_for :project_user_roles, allow_destroy: true, reject_if: :all_blank
  validates :join_date, presence: true
  validates :due_date, presence: true
  validates :user_id, uniqueness: { scope: :project_id }
  state_machine :state, initial: :joined do
    event :joined do
      transition :any => :joined
    end

    event :outed do
      transition :joined => :outed
    end

    state :joined
    state :outed
  end

  def convert_date
    self.out_date.blank? ? self.due_date.to_time.to_i*1000 : self.out_date.to_time.to_i*1000
  end

  def build_project_user_role project_role_id
    self.project_user_roles.build project_role_id: project_role_id
  end
end
