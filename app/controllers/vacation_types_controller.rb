class VacationTypesController < BaseController
  def index
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end

  def create
    respond_to do |format|
      if @vacation_type.save
        format.html { redirect_to vacation_types_path, notice: I18n.t(:create_success, scope: [:views, :messages], model: model_name) }
      else
        format.html { render action: :new }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      if @vacation_type.update_attributes(model_params)
        format.html { redirect_to url_for(action: :show), notice: I18n.t(:update_success, scope: [:views, :messages], model: model_name) }
      else
        format.html { render action: :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @vacation_type.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end

private
  def model_params
    params.require(:vacation_type).permit(:name) if params[:vacation_type]
  end
end