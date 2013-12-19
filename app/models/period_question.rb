class PeriodQuestion < Base
  belongs_to :checkpoint_period
  belongs_to :checkpoint_question

  validates :checkpoint_question_id, uniqueness: {scope: :checkpoint_period_id}, presence: true

  scope :by_type_question, ->parent_id {joins(:checkpoint_question).where("checkpoint_questions.checkpoint_type = ?", parent_id) unless parent_id.nil? }
  scope :get_parent_question, ->parent_id {joins(:checkpoint_question).where("checkpoint_questions.parent_id = ?", parent_id) unless parent_id.nil? }
end
