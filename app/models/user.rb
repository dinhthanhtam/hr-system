class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :cardID, :display_name, :team_id, :position, :user_roles_attributes, :group_users_attributes
  # attr_accessible :title, :body
  validates :position, presence: true
  validates :user_roles, presence: true

  has_many :reports
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :teams, through: :groups
  has_many :favourites
  has_many :project_users
  has_many :projects, through: :project_users
  mount_uploader :avatar, AvatarUploader

  belongs_to :team

  accepts_nested_attributes_for :user_roles, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :group_users, allow_destroy: true, reject_if: :all_blank

  scope :not_report_last_week, -> { where("users.id not in (#{Report.last_week_reports.select('user_id').to_sql})") }
  scope :not_report_current_week, -> { where("users.id not in (#{Report.current_week_reports.select('user_id').to_sql})") }
  scope :in_teams, ->(team_ids) { where("users.team_id in (?)", team_ids) unless team_ids.nil? }
  scope :reporters, -> { joins(:user_roles => :role).where("roles.name in (?)", ["Leader", "Member"]).uniq }
  scope :filter_leaders, -> { joins(:user_roles => :role).where("roles.name = ?", "Leader").uniq }

  def reported?
    reports.current_week_reports.any?
  end
  
  def method_missing(name, *args)
    return super unless name =~ /\A(.+)_role\?\z/
    roles.map{ |r| r.name.downcase }.include?($1.downcase)
  end

  def is_staff?
    ["Member"].include? position
  end

  def is_leader?
    ["Leader", "Subleader"].include? position
  end

  def is_manager?
    ["Manager", "Submanager"].include? position
  end

  def is_hr?
    roles.map(&:name).include? Settings.role.hr
  end

  def is_reporter?
    is_staff? || is_leader?
  end

  private
  class << self
    def notice_report
      reporters.each do |user|
        unless user.reported?
          UserMailer.delay.notice_write_report(user)
        end
      end
    end

    def notice_users_not_report
      filter_leaders.each do |user|
        user_not_reports = in_teams([user.team_id]).not_report_last_week.to_a
        UserMailer.delay.notice_list_users_not_write_report(user, user_not_reports,
          DateUtils::Week.new.prev.to_string) if user_not_reports.any?
      end
    end
  end
end
