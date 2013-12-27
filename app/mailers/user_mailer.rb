class UserMailer < ActionMailer::Base
  default :from => "hr@framgia.com"
 
  def sent_password(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: t(:welcome_subject, scope: [:mailers, :subjects]))
  end

  def notice_write_report(user)
    @user = user
    mail to: @user.email, subject: t(:notice_write_report, scope: [:mailers, :subjects])
  end

  def notice_list_users_not_write_report(user, users, date_string)
    @user = user
    @users = users
    @date_string = date_string
    mail to: @user.email, subject: t(:notice_write_report_for_leader, scope: [:mailers, :subjects])
  end

  def send_payslip payslip, deadline
    @payslip = payslip
    @user = payslip.user
    @deadline = deadline.nil? ? DateTime.now + 24.hours : DateTime.strptime(deadline, '%H:%M %d-%m-%Y')
    attachments["#{@user.display_name} #{payslip.paymonth}.xlsx"] = File.read(Rails.root.to_s + "/public" + payslip.payslip_url)
    mail to: @user.email, subject: t(:send_payslip, scope: [:mailers, :subjects], month: @payslip.paymonth_format("%b %Y"))
  end

  def notice_user_added_to_pickup_list user
    @user = user
    mail to: @user.email, subject: t(:notice_user_added_to_pickup_list, scope: [:mailers, :subjects])
  end
end
