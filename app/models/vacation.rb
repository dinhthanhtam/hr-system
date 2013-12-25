class Vacation < Base
  belongs_to :user
  belongs_to :vacation_type

  validates :user_id, presence: true
  validates :vacation_type_id, presence: true
end
