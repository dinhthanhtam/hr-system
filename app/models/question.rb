class Question < ActiveRecord::Base
  validates :name, presence: true
  has_many :question_type_relations, dependent: :destroy
  scope :question_not_in, ->ids{where 'questions.id NOT IN (?)', ids}
  
private
  class << self
    def updatable_attrs
      [:name, :content, :checkpoint_type]
    end
  end
end