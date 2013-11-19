class Report < ActiveRecord::Base
  #attr_accessible :report_category_id, :report_date, :description, :month, :user_id, :week, :year

  belongs_to :report_category
  belongs_to :user
  has_many :stickies

  validates :user, :report_category, presence: true
  validates :week, length: { maximum: 53, minimum: 0 }
  validates :month, length: { maximum: 12, minimum: 1 }
  validates :title, presence: true
  validates :description, presence: true
  validate :report_date, presence: true
  validate :valid_report_date

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
  scope :range_of_report, ->(from,to) { where("report_date BETWEEN ? and ?", from, to) }

  def in_current_week?
    Date.today.cweek == week && Date.today.year == year
  end

  def is_stickied? user_id
    self.stickies.where(user_id: user_id).any?
  end

  def valid_report_date
    errors.add(:report_date, I18n.t(:in_valid, scope: [:errors, :messages])) if
      (DateTime.now().cweek != report_date.cweek || !((1..5).include? report_date.wday) ||
      report_date > DateTime.now())
  end
end
