class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :cardID, :display_name, :team_id, :position, :user_roles_attributes, :group_users_attributes
  # attr_accessible :title, :body

  has_many :reports
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :group_users
  has_many :group, through: :group_users
  has_many :favourites
  mount_uploader :avatar, AvatarUploader

  belongs_to :team

  accepts_nested_attributes_for :user_roles, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :group_users, allow_destroy: true, reject_if: :all_blank

  scope :not_report_last_week, -> { where("id not in (?)", Report.last_week_reports.select("user_id").to_sql) }

  def reported?
    reports.current_week_reports.any?
  end
  
  def method_missing(name, *args)
    return super unless name =~ /\A(.+)_role\?\z/
    roles.map{ |r| r.name.downcase }.include?($1.downcase)
  end

  private
  class << self
    def notice_report
      all.each do |user|
        unless user.reported?
          UserMailer.delay.notice_write_report(user)       
        end
      end
    end
  end
end
