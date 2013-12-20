class CheckpointQuestion < Base
  belongs_to :parent, foreign_key: :parent_id, class_name: CheckpointQuestion.name
  has_many :checkpoint_answers
  has_many :children, foreign_key: :parent_id, class_name: CheckpointQuestion.name

  scope :by_type, ->(type) { where("checkpoint_questions.checkpoint_type = ?", type) }
  scope :get_children, -> { where("checkpoint_questions.parent_id != 0") }
  scope :get_parent, -> { where("checkpoint_questions.parent_id = 0") }
end
