class PayslipsController < BaseController

  before_filter :accessable?
  before_filter :payslip_type_correct?, only: [:create]
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

  def show
    @payslipsheet = RubyXL::Parser.parse @payslip.payslip_fullurl
    respond_to do |format|
      format.html
      format.js
    end    
  end

  def create
    payslip_path = "/tmp/payslip.xlsx"
    FileUtils.cp(params[:payslip][:file].tempfile.path, payslip_path)
    Payslip.delay.import_payslips(payslip_path)
    respond_to do |format|
      format.html { redirect_to payslips_path }
    end
  end

  def download
    payslip = Payslip.where(id: params[:id]).first
    send_file payslip.payslip_fullurl, type: "application/xlsx", x_sendfile: true if payslip
  end

  def send_payslip
    payslip = Payslip.where(id: params[:payslip][:payslip_id]).first if params[:payslip][:payslip_id]
    Payslip.send_payslip_mail(params[:payslip][:paymonth], payslip) unless params[:payslip][:payslip_id] && payslip.nil?
    respond_to do |format|
      if params[:payslip] && params[:payslip][:paymonth]
        format.html { redirect_to payslips_path }
      else
        format.html { redirect_to payslips_path, notice: "Please select paymonth!" }
      end
    end
  end

  private
  def accessable?
    unless Settings.payslip.accessable.include?(current_user.uid)
      flash[:error] = "Access denied"
      redirect_to root_path
    end
  end

  def payslip_type_correct?
    unless params[:payslip] && params[:payslip][:file].content_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      flash[:error] = "Please select .xlsx file!"
      redirect_to payslips_path
    end
  end
end
