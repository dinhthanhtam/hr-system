class Question < ActiveRecord::Base
  validates :name, presence: true
  has_many :question_type_relations, dependent: :destroy
  has_many :question_types, through: :question_type_relations, source: :question_type
  has_many :checkpoint_answers
  scope :question_not_in, ->ids{where 'questions.id NOT IN (?)', ids}
  scope :by_type, ->(type) { where("questions.checkpoint_type = ?", type) }
private
  class << self
    def updatable_attrs
      [:name, :content, :checkpoint_type]
    end
  end
end
