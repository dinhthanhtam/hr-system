class QuestionTypeRelationsController < BaseController
  def index
    respond_to do |format|
      format.html
    end
  end

  def destroy
    respond_to do |format|
      if @question_type_relation.destroy
        format.html { redirect_to question_type_question_type_relations_path(@question_type), 
          notice: I18n.t(:delete_success, scope: [:views, :messages], model: model_name) }
      else
        format.html { redirect_to question_type_question_type_relations_path(@question_type),
          notice: I18n.t(:delete_failed, scope: [:views, :messages], model: model_name) }
      end
    end
  end
private
  def ordering(search)
    @question_type.questions.present? ? Question.question_not_in(@question_type.question_ids) : Question.all
   end
end