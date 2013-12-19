class CheckpointQuestion < Base
  has_many :checkpoint_answers
  scope :by_type, ->(type) { where("checkpoint_questions.checkpoint_type = ?", type) }
  scope :by_period, ->(period) { where("checkpoint_questions.checkpoint_period_id = ?", period) }
end
