class VacationType < Base
  has_many :vacations
  validates :name, presence: true
end
