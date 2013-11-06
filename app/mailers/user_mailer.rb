class UserMailer < ActionMailer::Base
  default :from => "framgiatest@gmail.com"
 
  def sent_password(user, password)
    @user = user
    @password = password
    mail(to: @user.email, subject: t(:welcome_subject, scope: [:views, :labels]))
  end
end