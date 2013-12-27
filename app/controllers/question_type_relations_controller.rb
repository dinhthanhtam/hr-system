class QuestionTypeRelationsController < BaseController
  def index
    @questions = @question_type.questions.present? ? 
      Question.question_not_in(@question_type.question_ids) : Question.all
    @question_relations = @question_type.question_type_relations.paginate page: params[:page]
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
end