class CostsController < BaseController
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
      if @cost.save
        format.html { redirect_to project_costs_path, notice: I18n.t(:create_success, scope: [:views, :messages], model: model_name) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      @cost.week = Date.parse(params[:week]).cweek if params[:week].present?
      if @cost.update_attributes(model_params)
        format.html { redirect_to url_for(action: :show), notice: I18n.t(:update_success, scope: [:views, :messages], model: model_name) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @cost.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end

private
  def ordering(search)
    @project.costs
  end

  def create_object
    super
    @cost = @project.costs.build(model_params)
    @cost.mon_of_week ||= Date.today.monday
    @cost.user_id = current_user.user_id
  end
  
  def model_params
    params.require(:cost).permit(:cost, :mon_of_week, :project_id) if params[:cost]
  end
end
