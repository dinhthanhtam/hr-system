class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :cardID, :display_name, :team_id, :position, :user_roles_attributes, :group_users_attributes
  # attr_accessible :title, :body

  has_many :reports
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :group_users
  has_many :group, through: :group_users

  belongs_to :team

  accepts_nested_attributes_for :user_roles, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :group_users, allow_destroy: true, reject_if: :all_blank
end
