class QuestionTypeRelation < ActiveRecord::Base
  belongs_to :question
  belongs_to :question_type
  validates :question_id, uniqueness: { scope: :question_type_id }
end
