class Group < Base
  include ActiveModel::ForbiddenAttributesProtection
  #attr_accessible :name
  has_many :teams
  has_many :users, through: :teams
  has_many :group_users, dependent: :destroy
  has_many :managers, through: :group_users, source: :user
  belongs_to :parent, class_name: Group.name
  has_many :children, class_name: Group.name, foreign_key: :parent_id

  validates :parent, presence: true, if: -> { parent_id? }

  scope :root_groups, -> { where("parent_id is ?", nil) }

  def descendant_groups
    if self.children.empty?
      return [self]
    else
      result = [self]
      self.children.each do |child|
        result += child.descendant_groups
      end
      return result
    end
  end

  def users_number
    descendant_groups.inject(0) { |result, group| result += group.teams.inject(0) {|count, team| count += team.users.count }}
  end
end
