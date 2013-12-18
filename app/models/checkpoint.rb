class Checkpoint < Base

  scope :by_periods, ->(period_id) { where("checkpoints.checkpoint_period_id = ?", period_id) unless period_id.nil? }
end
