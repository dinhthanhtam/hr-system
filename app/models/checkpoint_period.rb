class CheckpointPeriod < Base
  has_many :checkpoints, dependent: :destroy
  has_many :checkpoint_questions
  has_many :period_questions
  has_many :checkpoint_questions, through: :period_questions, source: :checkpoint_question

  accepts_nested_attributes_for :period_questions, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :period_questions, presence: true

  def toString
    "#{self.name}(#{self.start_date}~#{self.end_date})"
  end

  def build_period_question checkpoint_question_id
    self.period_questions.where(checkpoint_question_id: checkpoint_question_id).presence ||
      self.period_questions.build(checkpoint_question_id: checkpoint_question_id)
  end
private
  class << self
    def updatable_attrs
      [:name, :start_date, :end_date,
        period_questions_attributes: [:id, :_destroy, :checkpoint_question_id, :checkpoint_period_id]]
    end
  end
end