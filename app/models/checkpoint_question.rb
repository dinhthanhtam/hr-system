class CheckpointQuestion < Base
  has_many :checkpoint_answers
  has_many :children , foreign_key: :parent_id, class_name: CheckpointQuestion.name
  belongs_to :checkpoint_question, foreign_key: :parent_id, class_name: CheckpointQuestion.name
  scope :by_type, ->(type) { where("checkpoint_questions.checkpoint_type = ?", type) }
end
