class Sticky < Base
  validates :user_id, uniqueness: { scope: :report_id }
  belongs_to :user
  belongs_to :report

  scope :count_by_manager_or_leader, ->(report_ids, user_id) { where("report_id in (?) AND user_id <> (?)", report_ids, user_id) }
end
