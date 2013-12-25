class QuestionTypesController < BaseController
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
      if @question_type.save
        format.html { redirect_to question_types_path, 
          notice: I18n.t(:create_success, scope: [:views, :messages], model: model_name) }
      else
        format.html { render action: :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @question_type.update_attributes(model_params)
        format.html { redirect_to url_for(action: :show), 
          notice: I18n.t(:update_success, scope: [:views, :messages], model: model_name) }
      else
        format.html { render action: :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @question_type.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end

  def add_questions
    @question_type = QuestionType.find params[:question_type][:id]
    respond_to do |format|
      if @question_type.update_attributes model_params
        format.html { redirect_to url_for(action: :index, controller: :question_type_relations, 
          question_type_id: @question_type.id)} 
      else
        format.html { redirect_to url_for(action: :index)}
      end
    end
  end

private
  def model_params
    params.require(:question_type).permit QuestionType.updatable_attrs if params[:question_type]
  end
end