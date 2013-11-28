class ProjectUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
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
end
