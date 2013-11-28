class ProjectsController < BaseController

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
      if @project.save
        format.html { redirect_to @project, notice: t(:create_success, scope: [:views, :messages]) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update_attributes(model_params)
        format.html { redirect_to @project, notice: t(:create_success, scope: [:views, :messages]) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @project.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end

  def gantt_list
    respond_to do |format|
      format.html
    end
  end


  def gantt
    @list_gantt = User.reporters.map do |user|
      projects = user.project_users.map do |project_user|
        {from: "/Date(#{project_user.join_date.to_time.to_i*1000})/", to: "/Date(#{project_user.convert_date})/" , label: project_user.project.name, customClass: ["ganttRed","ganttGreen","ganttBlue"].sample }
      end
      {:name => user.display_name, values: projects}
    end
    respond_to do |format|
      format.json {render json: @list_gantt}
    end
  end

private
  def model_params
    params.require(:project).permit(:name, :description, :is_publish, :url, :start_date, :due_date, :state_event, 
                                    project_users_attributes: [:id, :user_id, :project_id, :_destroy]) if params[:project]
  end
end
