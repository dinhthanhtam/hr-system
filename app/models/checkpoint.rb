class Checkpoint < Base

  belongs_to :checkpoint_period

  validates :user_id, uniqueness: {scope: :checkpoint_period_id}, presence: true

  scope :by_periods, ->(period_id) { where("checkpoints.checkpoint_period_id = ?", period_id) unless period_id.nil? }
end
