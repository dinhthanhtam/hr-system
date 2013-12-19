class CheckpointAnswer < Base
  belongs_to :checkpoint_question
  belongs_to :checkpoint
  has_many :user_answer_comments
  accepts_nested_attributes_for :user_answer_comments, allow_destroy: true
end
