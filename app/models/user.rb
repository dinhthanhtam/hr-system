class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :cardID, :display_name, :team_id, :position, :user_roles_attributes, :group_users_attributes
  # attr_accessible :title, :body
  validates :user_roles, presence: true
  validates :uid, uniqueness: true, format: { with: /\A(A|B)(\d+)\z/ }
  validates :gender, inclusion: { in: Settings.users.gender, message: I18n.t(:in_valid, scope: [:errors, :messages]) },
            allow_nil: true, allow_blank: true
  validates :marital_status, inclusion: { in: Settings.users.marital_status, message: I18n.t(:in_valid, scope: [:errors, :messages]) },
            allow_nil: true, allow_blank: true
  validates :tel, numericality: true, length: { in: 10..11 }, allow_nil: true, allow_blank: true
  validates :identity_id, uniqueness: true, numericality: true, length: { is: 9 }, allow_nil: true, allow_blank: true
  validates :contract_type, inclusion: { in: Settings.users.contract_types, message: I18n.t(:in_valid, scope: [:errors, :messages]) },
            allow_nil: true, allow_blank: true

  has_many :reports
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :teams, through: :groups
  has_many :stickies
  has_many :project_users
  has_many :projects, through: :project_users
  has_many :feedbacks
  mount_uploader :avatar, AvatarUploader
  
  # payslip
  has_many :payslips

  belongs_to :team

  accepts_nested_attributes_for :user_roles, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :group_users, allow_destroy: true, reject_if: :all_blank

  scope :not_report_last_week, -> { where("users.id not in (#{Report.last_week_reports.select('user_id').to_sql})") }
  scope :not_report_current_week, -> { where("users.id not in (#{Report.current_week_reports.select('user_id').to_sql})") }
  scope :in_teams, ->(team_ids) { where("users.team_id in (?)", team_ids) unless team_ids.nil? }
  scope :reporters, -> { joins(:user_roles => :role).where("roles.name in (?)", ["leader", "member"]).uniq }
  scope :filter_leaders, -> { joins(:user_roles => :role).where("roles.name = ?", "leader").uniq }
  scope :in_groups, ->(group_ids) { in_teams(Team.in_groups(group_ids).ids) }
  
  scope :find_leaders, -> { where("users.position = ?", "leader") }
  scope :find_managers, -> { where("users.position = ?", "manager") }
  scope :find_submanagers, -> { where("users.position = ?", "submanager") }
  scope :find_subleaders, -> { where("users.position = ?", "subleader") }
  scope :find_members, -> { where("users.position = ?", "member") }
  
  state_machine :position, initial: :member do
    after_transition [:manager, :submanager] => any - [:manager, :submanager] do |user, transition|
      user.group_users.try(:destroy_all)
    end

    after_transition any => [:manager, :submanager] do |user, transition|
      user.team_id = nil
      user.save
    end

    event :member do
      transition all => :member
    end

    event :subleader do
      transition all => :subleader
    end

    event :leader do
      transition all => :leader
    end

    event :submanager do
      transition all => :submanager
    end

    event :manager do
      transition all => :manager
    end

    event :chief do
      transition all => :chief
    end

    state :member
    state :subleader
    state :leader
    state :submanager
    state :manager
    state :chief
  end

  def reported?
    reports.current_week_reports.any?
  end
  
  def method_missing(name, *args)
    return super unless name =~ /\A(.+)_role\?\z/
    roles.map{ |r| r.name.downcase }.include?($1.downcase)
  end

  def is_staff?
    member?
  end

  def is_leader?
    leader? || subleader?
  end

  def is_manager?
    manager? || submanager?
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
