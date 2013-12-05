class UsersController < BaseController

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

  def personal_settings
    @user = User.find(params[:id])
    respond_to do |format|
        format.html
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

  def update_profile
    @id = params[:user].keys.last
    @user = current_user
    respond_to do |format|
      if @success = @user.update_attributes(model_params)
        sign_in(current_user, :bypass => true) if params[:user][:password].present? || params[:user][:password_confirmation].present?
        format.js
      else
        format.js
      end
    end
  end

private
  def ordering(search)
    if params[:group] && !params[:group].empty?
      return User.in_teams(Team.in_groups(Group.find(params[:group]).descendant_groups.map(&:id)).map(&:id)).order(:uid)
    elsif params[:team] && !params[:team].empty?
      return Team.find(params[:team]).users.order(:uid)
    else
      return User.order(:uid)
    end
  end
  def model_params
    params.require(:user).permit(:uid, :email, :password, :password_confirmation, :remember_me,
                                 :cardID, :display_name, :team_id, :position_event, :avatar,
                                 user_roles_attributes: [:id, :user_id, :role_id, :_destroy],
                                 group_users_attributes: [:id, :user_id, :group_id, :_destroy]) if params[:user]
  end
end
