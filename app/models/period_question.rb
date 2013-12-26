class PeriodQuestion < Base
  belongs_to :checkpoint_period
  belongs_to :question

  validates :question_id, uniqueness: {scope: :checkpoint_period_id}, presence: true

  scope :by_type_question, ->parent_id {joins(:question).where("questions.checkpoint_type = ?", parent_id) unless parent_id.nil? }

end
