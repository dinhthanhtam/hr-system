class Cost < Base
  belongs_to :project
  validates :cost, numericality: { only_integer: true }
  validates :week, uniqueness: { scope: :year }
end
