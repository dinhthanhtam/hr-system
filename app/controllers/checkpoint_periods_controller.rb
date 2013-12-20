class CheckpointPeriodsController < BaseController
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
      if @checkpoint_period.save
        format.html { redirect_to @checkpoint_period,
                      notice: I18n.t(:create_success, model: model.model_name.human, scope: [:views, :messages]) }
      else
        format.html { render action: :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @checkpoint_period.update_attributes(model_params)
        format.html { redirect_to @checkpoint_period,
                      notice: I18n.t(:update_success, model: model.model_name.human, scope: [:views, :messages]) }
      else
        format.html { render action: :new }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @checkpoint_period.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end
private
  def model_params
    params.require(:checkpoint_period).permit CheckpointPeriod.updatable_attrs if params[:checkpoint_period]
  end
end
