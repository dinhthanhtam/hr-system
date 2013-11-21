class UserMailer < ActionMailer::Base
  default :from => "framgiatest@gmail.com"
 
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
end
