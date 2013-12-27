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
        if params[:project][:project_users_attributes]
          format.html { redirect_to url_for(controller: :project_users, action: :index, project_id: @project.id),
            notice: t(:update_success, scope: [:views, :messages]) }
        else
          format.html { redirect_to @project, notice: t(:update_success, scope: [:views, :messages]) }
        end
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
    @gantt_scale = params[:gantt_scale]
    date_ranger = DateRanger.new(join_dates.min, out_dates.max, @gantt_scale)

    @list_users = User.reporters.map do |user|
      projects = user.project_users.map do |project_user|
        join_date = project_user.join_date
        out_date = Time.at(project_user.convert_date / 1000).to_date
        if @gantt_scale == Settings.gantt.scale_type.weeks
          [project_user.project.try(:name),
            [date_ranger.get_week_of_years(join_date), date_ranger.get_month_of_years(join_date), date_ranger.get_year_of_weeks(join_date)],
            [date_ranger.get_week_of_years(out_date), date_ranger.get_month_of_years(out_date), date_ranger.get_year_of_weeks(out_date)]]
        else
          [project_user.project.try(:name), [join_date.day, join_date.month, join_date.year],
            [out_date.day, out_date.month, out_date.year]]
        end
      end
      # Return name of user and list project with process of user
      [user.display_name, projects]
    end
    convert_to_index(@list_users, date_ranger.try(@gantt_scale))
    sort_by_join_date @list_users
    @titles = date_ranger.get_titles_array

    respond_to do |format|
      format.xls { headers["Content-Disposition"] = "attachment; filename=projects_gantt.xls" }
    end
  end

private
  def model_params
    params.require(:project).permit Project.updatable_attrs if params[:project]
  end

  def sort_by_join_date list_users
    list_users.each do |user_project|
      user_project[1].sort! { |x, y| x[1] <=> y[1] }
    end
  end

  def convert_to_index list_users, array_type
    length = array_type.first.length
    list_users.each do |user_project|
      user_project[1].each do |project|
        project[1] = array_type.index(project[1].last(length))
        project[2] = array_type.index(project[2].last(length))
      end
    end
  end
end
