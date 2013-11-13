class GroupsController < BaseController
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
      if @group.save
        format.html { redirect_to groups_path, notice: "Create group successfully!" }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update_attributes(model_params)
        format.html { redirect_to url_for(action: :show), notice: "Update group successfully!" }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @group.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end
private
  def model_params
    params.require(:group).permit(:name, :parent_id) if params[:group]
  end
end
