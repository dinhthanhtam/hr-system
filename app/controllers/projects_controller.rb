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
        format.html { redirect_to @project, notice: t(:update_success, scope: [:views, :messages]) }
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
        {from: "/Date(#{project_user.join_date.to_time.to_i*1000})/", to: "/Date(#{project_user.convert_date})/" ,
         label: project_user.project.name, customClass: ["ganttRed","ganttGreen","ganttBlue"].sample }
      end
      {:name => user.display_name, values: projects}
    end
    respond_to do |format|
      format.json {render json: @list_gantt}
    end
  end

  def export_excel
    join_dates = ProjectUser.where(user_id: [User.reporters.map(&:id)]).map(&:join_date)
    out_dates = ProjectUser.where(user_id: [User.reporters.map(&:id)]).map(&:convert_date)
    out_dates = out_dates.map{ |out_date| Time.at(out_date / 1000).to_date }
    # Sunday belong to last week
    firstWedDay = join_dates.min.sunday? ? (join_dates.min - 4) : (join_dates.min + 3 - join_dates.min.wday)
    lastWedDay = out_dates.max.sunday? ? (out_dates.max - 4) : (out_dates.max + 3 - out_dates.max.wday)
    @weeks = []
    while firstWedDay <= lastWedDay
      @weeks << [firstWedDay.cweek, firstWedDay.month, firstWedDay.year]
      firstWedDay += 7.day
    end
    # Get process project for reporters
    @list_users = User.reporters.map do |user|
      projects = user.project_users.map do |project_user|
        # Set join and out date is wednessday same week with join and out date
        join_date = project_user.join_date
        join_date = join_date.sunday? ? (join_date - 4) : (join_date + 3 - join_date.wday)
        out_date = Time.at(project_user.convert_date / 1000).to_date
        out_date = out_date.sunday? ? (out_date -4) : (out_date + 3 - out_date.wday)
        [project_user.project.try(:name), @weeks.index([join_date.cweek, join_date.month, join_date.year]),
          @weeks.index([out_date.cweek, out_date.month, out_date.year])]
      end
      # Return name of user and list project with process of user
      [user.display_name, projects]
    end
    # Sort by join date of project
    @list_users.each do |user|
      user[1].sort! { |x, y| x[1] <=> y[1] }
    end
    # Group and count month with year
    months = @weeks.map { |week| [week[1], week[2]] }
    @months = months.uniq
    @months = @months.map { |month| [Date::MONTHNAMES[month[0]], months.count(month)] }
    # Group and count year
    years = @weeks.map { |week| week[2] }
    @years = years.uniq
    @years = @years.map { |year| [year, years.count(year)] }

    respond_to do |format|
      format.xls { headers["Content-Disposition"] = "attachment; filename=projects_gantt.xls" }
    end
  end

  def assign_members
    @project = Project.find params[:project][:id]
    respond_to do |format|
      if @project.update_attributes(model_params)
        format.js
      else
        format.js
      end
    end
  end

private
  def model_params
    params.require(:project).permit(:name, :description, :is_publish, :url, :start_date, :due_date, :end_date, :state_event, :create_user_id,
                                    project_users_attributes: [:id, :user_id, :project_id, :join_date, :due_date, :_destroy, 
                                    project_user_roles_attributes: [:id, :project_user_id, :project_role_id, :_destroy]]) if params[:project]
  end
end
