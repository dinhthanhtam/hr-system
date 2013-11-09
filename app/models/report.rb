class Report < ActiveRecord::Base
  #attr_accessible :report_category_id, :report_date, :description, :month, :user_id, :week, :year

  belongs_to :report_category
  belongs_to :user
  has_many :favourites

  validates :user, :report_category, presence: true
  validates :week, length: { maximum: 53, minimum: 0 }
  validates :month, length: { maximum: 12, minimum: 1 }

  scope :in_week, ->(week) { where(week: week) }
  scope :in_month, ->(month) { where(month: month) }
  scope :in_year, ->(year) { where(year: year) }

  scope :in_month_year, ->(month, year) { in_year(year).in_month(month) }
  scope :in_week_month_year, ->(week, month, year) { in_month_year(month, year).in_week(week) }

  scope :group_by_years, -> { group(:year) }
  scope :group_by_months, ->(year) { in_year(year).group(:month) }
  scope :group_by_weeks, ->(month, year) { in_month_year(month, year).group(:week) }
  
  scope :current_week_reports, -> { in_year(Date.today.year).in_week(Date.today.cweek) }
  scope :last_week_reports, -> { in_year(Date.today.year).in_week(Date.today.cweek - 1) }

  def in_current_week?
    Date.today.cweek == week && Date.today.year == year
  end

  def is_favourited? user_id
    self.favourites.where(user_id: user_id).any?
  end
end
