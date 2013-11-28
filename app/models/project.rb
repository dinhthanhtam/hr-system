class Project < Base

  validates :url, format: { with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix }, allow_nil: true, allow_blank: true
  has_many :project_users
  has_many :users, through: :project_users
  has_many :costs
  scope :get_project_by_state, ->(state) { where("state = ?", state) }

  state_machine :state, initial: :prepared do
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
