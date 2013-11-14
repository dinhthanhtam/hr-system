class Group < Base
  include ActiveModel::ForbiddenAttributesProtection
  #attr_accessible :name
  has_many :teams
  has_many :users, through: :teams
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
end
