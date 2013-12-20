class CheckpointPeriod < Base
  has_many :checkpoints, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  has_many :period_questions
  has_many :checkpoint_questions, through: :period_questions, source: :checkpoint_question

  def toString
    "#{self.name}(#{self.start_date}~#{self.end_date})"
  end
end
