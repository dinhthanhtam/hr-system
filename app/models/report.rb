class Report < ActiveRecord::Base
  #attr_accessible :report_category_id, :report_date, :description, :month, :user_id, :week, :year

  belongs_to :report_category
  belongs_to :user
  has_many :stickies
  has_many :support_users

  validates :user, :report_category, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validate :report_date, presence: true
  validate :valid_report_date

  scope :in_week, ->(from, to) { where("reports.report_date BETWEEN ? AND ?", from, to) }
  scope :in_month, ->(month) { where("MONTH(reports.report_date) = ?", month) }
  scope :in_year, ->(year) { where("YEAR(reports.report_date) = ?",year) }
  scope :in_month_year, ->(month, year) { in_year(year).in_month(month) }

  scope :group_by_years, -> { group(:year) }
  scope :group_by_months, ->(year) { in_year(year).group(:month) }
  scope :group_by_weeks, ->(month, year) { in_month_year(month, year).group("WEEK(report_date)") }
  
  scope :current_week_reports, -> {
    in_week((week = DateUtils::Week.new).start_day, week.end_day) 
  }
  scope :last_week_reports, -> {
    in_week((lastweek = DateUtils::Week.new.prev).start_day, lastweek.end_day) 
  }
  scope :range_of_report, ->(from,to) { where("reports.report_date BETWEEN ? and ?", from, to) }

  accepts_nested_attributes_for :support_users, allow_destroy: true, reject_if: :all_blank

  ransacker :report_date_month do |parent|
    Arel::Nodes::SqlLiteral.new("MONTH(reports.report_date)")
  end

  ransacker :report_date_year do |parent|
    Arel::Nodes::SqlLiteral.new("YEAR(reports.report_date)")
  end

  def week
    report_date.cweek
  end

  def month
    report_date.month
  end

  def year
    report_date.year
  end

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
