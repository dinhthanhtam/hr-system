class QuestionType < ActiveRecord::Base
  has_many :question_type_relations, dependent: :destroy
  has_many :questions, through: :question_type_relations
  accepts_nested_attributes_for :question_type_relations, allow_destroy: true, 
    reject_if: :all_blank
    
private
  class << self
    def updatable_attrs
      [:name, :description, question_type_relations_attributes: [:id, :question_id,
        :question_type_id]]
    end
  end
end