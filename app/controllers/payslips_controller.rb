class PayslipsController < BaseController

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
    Payslip.send_payslip_mail(params[:payslip][:paymonth])
    respond_to do |format|
      format.html { redirect_to payslips_path }
    end
  end
end
