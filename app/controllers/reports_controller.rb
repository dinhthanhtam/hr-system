class ReportsController < BaseController

  before_filter :check_editable?, only: [:edit, :update, :destroy]
  
  def index
    respond_to do |format|
      create_object
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
      if @report.save
        format.html { redirect_to reports_path, notice: I18n.t(:create_success, scope: [:views, :messages], model: model_name) }
      else
        @search = Report.search(params[:q])
        @reports = @search.result.paginate(page: params[:page],per_page: params[:per_page])
        format.html { render "index" }
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
      if @report.update_attributes(model_params)
        format.html { redirect_to url_for(action: :show), notice: I18n.t(:update_success, scope: [:views, :messages], model: model_name) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @report.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end

  def summary
    @users = current_user.is_manager? ? User.in_groups(current_user.groups.map(&:id)) : User.in_teams(current_user.team.id)
    @list_sumary = @users.map do |user|
      params[:report_to] = Date.today.strftime("%Y-%m-%d") if params[:report_to].blank?
      params[:report_from] = DateTime.now.beginning_of_year.strftime("%Y-%m-%d") if params[:report_from].blank?
      reports = user.reports.range_of_report(params[:report_from], params[:report_to])
      stickies = reports.sticked_by(user.id).count
      stickies_by_leader = reports.not_sticked_by(user.id).count
      number_of_stikies = reports.sticked_reports.count
      beginning = DateTime.parse(params[:report_from]).beginning_of_week
      end_week = DateTime.parse(params[:report_to]).beginning_of_week
      number_of_weeks = (end_week - beginning).to_i/7 - reports.group_by_years.group_by_weeks_for_summary.count.length
      [user.display_name, reports.count, stickies, stickies_by_leader, number_of_stikies, number_of_weeks]
    end
    
    respond_to do |format|
      format.html
    end
  end

private
  def ordering(search)
    if current_user.is_manager?
       params[:member_id] = User.in_groups(current_user.groups.map(&:id)).first.try(:id) unless params[:member_id]
       User.find(params[:member_id]).reports.order("report_date DESC")
    else
      params[:member_id] = nil if current_user.is_staff? || current_user.is_hr?
      (params[:member_id].present? ? User.find(params[:member_id]) : current_user).reports.order("report_date DESC")
    end
  end

  def create_object
    super
    @report.user = current_user
    report_date = params[:report][:report_date].to_date if params[:report]
    report_date ||= Date.today
    @report.report_date = report_date
  end

  def check_editable?
    redirect_to url_for(action: :index) unless @report.in_current_week?
  end
    
  def model_params
     params.require(:report).permit(:report_category_id, :title, :description, :report_date, support_users_attributes: [:id, :user_id, :report_id, :_destroy]) if params[:report]
  end
end
