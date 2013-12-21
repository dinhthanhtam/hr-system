class PickupListsController < BaseController

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
      if @pickup_list.save
        format.html { redirect_to @pickup_list, notice: t(:create_success, scope: [:views, :messages]) }
      else
        format.html { render action: :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @pickup_list.update_attributes(model_params)
        format.html { redirect_to @pickup_list, notice: t(:update_success, scope: [:views, :messages]) }
      else
        format.html { render action: :new }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @pickup_list.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end

  def assign_members
    @pickup_list = PickupList.find params[:pickup_list][:id]
    respond_to do |format|
      if @pickup_list.update_attributes(model_params)
        format.js
      else
        format.js
      end
    end
  end

private
  def model_params
    params.require(:pickup_list).permit PickupList.updatable_attrs if params[:pickup_list] 
  end
end
