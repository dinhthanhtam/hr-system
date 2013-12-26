class CheckpointPeriod < Base
  has_many :checkpoints, dependent: :destroy
  has_many :questions
  has_many :period_questions
  has_many :questions, through: :period_questions, source: :question

  accepts_nested_attributes_for :period_questions, allow_destroy: true, reject_if: :all_blank

  validates :name, :description, :start_date, :end_date, presence: true
  validates :period_questions, presence: true

  def toString
    "#{self.name}(#{self.start_date}~#{self.end_date})"
  end

  def build_period_question question_id
    self.period_questions.where(question_id: question_id).presence ||
      self.period_questions.build(question_id: question_id)
  end
private
  class << self
    def updatable_attrs
      [:name, :start_date, :end_date, :description,
        period_questions_attributes: [:id, :_destroy, :question_id, :checkpoint_period_id]]
    end
  end
end
