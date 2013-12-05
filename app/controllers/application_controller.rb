class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end
  layout Proc.new { |controller| controller.devise_controller? ? 'signin' : 'application' }

private
  def after_sign_out_path_for(resource)
    session[:previous_url] || new_user_session_path
  end

  def sign_out(resource_or_scope=nil)
    if session.empty?
      return
    else
      super
    end
  end  
end
