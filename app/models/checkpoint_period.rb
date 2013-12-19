class CheckpointPeriod < Base
  has_many :checkpoints, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  has_many :checkpoint_questions

  def toString
    "#{self.name}(#{self.start_date}~#{self.end_date})"
  end
end
