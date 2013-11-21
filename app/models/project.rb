class Project < Base
  has_many :project_users
  has_many :users, through: :project_users
  has_many :costs

  state_machine :state, initial: :prepared do
    after_transition to: :finished do |project, transition|
      project.end_date = Date.today
      project.save
    end

    event :prepare do
      transition :prepared => :prepared
    end

    event :activate do
      transition [:prepared, :actived] => :actived
    end

    event :finish do
      transition :actived => :finished
    end

    state :prepared
    state :actived
    state :finished
  end

  accepts_nested_attributes_for :project_users, allow_destroy: true, reject_if: :all_blank

  def preparable?
    prepared?
  end

  def activatable?
    prepared? || actived?
  end

  def finishable?
    actived?
  end

  def editable?
    !finished?
  end

  def deletable?
    prepared?
  end
end