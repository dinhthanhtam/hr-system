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

  def get_reports_by_user
    if params[:from].present? || params[:to].present?
      @report = Report.where(user_id: params[:user_id]).group_by_years.range_of_report(params[:from], params[:to]).count(group: params[:report_type])
    else
      @report = Report.where(user_id: params[:user_id], year: Date.today.year).group_by_years.count(group: params[:report_type])
    end

    date = []
    if @report.present? && params[:report_type] == "month"
      @report.each do |r|
        date<< [Date::MONTHNAMES[r[0][1]].to_s + "," + r[0][0].to_s, r[1]]
      end
    elsif params[:report_type] == "week"
      @report.each do |r|
        date<< [ Date.commercial(r[0][0], r[0][1], 1) , r[1]]
      end
    end
    
    respond_to do |format|
      format.json { render json: date }
    end
  end

  def charts
    @report = Report.new
  end

private
  def ordering(search)
    params[:member_id] = nil if current_user.is_staff? || current_user.is_hr?
    (params[:member_id].present? ? User.find(params[:member_id]) : current_user).reports.order("report_date DESC")
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
