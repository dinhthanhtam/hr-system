class UserAnswerComment < Base
  belongs_to :user
  belongs_to :checkpoint_answer

  scope :by_checkpoint, ->(answer_ids) { where("user_answer_comments.checkpoint_answer_id in (?)", answer_ids) }
end
