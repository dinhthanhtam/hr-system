class UsersController < BaseController

  before_filter :check_role_show, only: :show

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

  def create
    password = SecureRandom.hex(3)
    @user.update_attributes(password: password, password_confirmation: password)
    respond_to do |format|
      if @user.save
        UserMailer.delay.sent_password(@user, password)
        format.html { redirect_to @user, notice: t(:create_user_success, scope: [:views, :messages]) }
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
      if @user.update_attributes(model_params)
        format.html { redirect_to url_for(action: :show), notice: I18n.t(:update_success, model: model.model_name.human, scope: [:views, :messages]) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to action: :index }
      else
        format.html { render action: request.referer }
      end
    end
  end

  def get_team
    respond_to do |format|
      format.json { render json: Group.find(params[:group_id]).teams.map { |team| [team.name, team.id] } }
    end
  end

  def get_all_user
    respond_to do |format|
      format.json { render json: User.all }
    end
  end

private
  def model_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me,
                                 :cardID, :display_name, :team_id, :position, :avatar,
                                 user_roles_attributes: [:id, :user_id, :role_id, :_destroy],
                                 group_users_attributes: [:id, :user_id, :group_id, :_destroy]) if params[:user]
  end

  def check_role_show
    if @user != current_user
      if current_user.is_staff?
        redirect_to root_path
      elsif current_user.is_leader?
        redirect_to root_path unless @user.team_id == current_user.team_id
      elsif current_user.is_manager?
        redirect_to root_path unless current_user.teams.map(&:id).include? @user.team_id
      end
    end
  end
end
