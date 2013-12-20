class Checkpoint < Base
  belongs_to :checkpoint_period

  validates :user_id, uniqueness: {scope: :checkpoint_period_id}, presence: true

  scope :by_periods, ->(period_id) { where("checkpoints.checkpoint_period_id = ?", period_id) unless period_id.nil? }
  scope :by_approve, ->(approve_id) { where("checkpoints.approve_id = ?", approve_id) unless approve_id.nil? }
  scope :by_reviewer, ->(review_id) { where("checkpoints.reviewer_id = ?", review_id) unless review_id.nil? }
  scope :approve, -> {where state: "approve"}
  scope :by_rank, ->rank { where("checkpoints.ranking = ?", rank) unless rank.nil? }

  has_many :checkpoint_answers, dependent: :destroy
  belongs_to :checkpoint_period
  belongs_to :user
  accepts_nested_attributes_for :checkpoint_answers, allow_destroy: true

  state_machine :state, initial: :waitting do
    event :reviewing do
      transition :waitting => :reviewing
    end

    event :reviewed do
      transition :reviewing => :reviewed
    end

    event :approve do
      transition :reviewed => :approve
    end

    state :waitting
    state :reviewing
    state :reviewed
    state :approve
  end

  def build_checkpoint_answers
    if self.checkpoint_answers.empty?
      self.checkpoint_period.checkpoint_questions.where("checkpoint_questions.parent_id > 0").by_type(self.user.position).
        order("checkpoint_questions.parent_id").each { |question| self.checkpoint_answers.build(checkpoint_question_id: question.id) }
    end
  end

  def build_checkpoint_comments(user_id)
    self.checkpoint_answers.each { |answer| answer.user_answer_comments.build(user_id: user_id) }
  end

  def new_checkpoint?
    waitting?
  end

  def reviewable?
    reviewing?
  end

  def approveable?
    reviewed?
  end
end
