class ProjectUsersController < BaseController
  def index
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      if @project_user.update_attributes(model_params)
        if request.xhr?
          format.js
        else
          format.html { redirect_to project_path(@project_user.project_id) }
        end
      else
        format { redirect_to action: :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @project_user.destroy
        format.html { redirect_to project_project_users_path(project_id: @project_user.project_id) }
      else
        format { redirect_to action: :edit }
      end
    end
  end

private
  def ordering(search)
    @project.project_users
  end

  def create_object
    super
    @project_user = @project.project_users.build(model_params)
  end

  def model_params
    params.require(:project_user).permit(:join_date, :due_date, :out_date, :state_event, project_role_ids: []) if params[:project_user]
  end
end
