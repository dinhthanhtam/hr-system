class Sticky < Base
  validates :user_id, uniqueness: { scope: :report_id }
  belongs_to :user
  belongs_to :report
end
