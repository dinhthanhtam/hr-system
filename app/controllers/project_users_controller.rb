class ProjectUsersController < BaseController
  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      if @project_user.update_attributes(model_params)
        format.html { redirect_to url_for(controller: :projects, action: :show, id: @project_user.project_id), notice: "Update group successfully!" }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @project_user.destroy
        format.html { redirect_to url_for(controller: :projects, action: :show, id: @project_user.project_id) }
      else
        format { redirect_to action: :edit }
      end
    end
  end

private
  def model_params
    params.require(:project_user).permit(:join_date, :due_date, :out_date, :state_event) if params[:project_user]
  end
end
