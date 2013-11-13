class ReportsController < BaseController

  before_filter :check_editable?, only: [:edit, :update, :destroy]

  def index
    respond_to do |format|
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
        format.html { render action: "new" }
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

private
  def ordering(search)
    (params[:member_id].present? ? User.find(params[:member_id]) : current_user).reports.order("report_date DESC")
  end

  def create_object
    super
    @report.user = current_user
    today = Date.today
    @report.report_date = today
    @report.week = today.cweek
    @report.month = today.month
    @report.year = today.year
  end

  def check_editable?
    redirect_to url_for(action: :index) unless @report.in_current_week?
  end

  def model_params
     params.require(:report).permit(:report_category_id, :description) if params[:report]
  end
end
