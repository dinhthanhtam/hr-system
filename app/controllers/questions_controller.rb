class QuestionsController < BaseController
  def index
    respond_to do |format|
      format.html
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def create
    respond_to do |format|
      if @question.save
        format.html { redirect_to questions_path, notice: I18n.t(:add_question_success, scope: [:views, :messages], model: model_name) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @question.update_attributes(model_params)
        format.html { redirect_to url_for(action: :show), notice: I18n.t(:update_success, scope: [:views, :messages], model: model_name) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @question.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end
private
  def model_params
    params.require(:question).permit Question.updatable_attrs if params[:question]
  end
end