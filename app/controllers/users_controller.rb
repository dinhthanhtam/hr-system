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
        UserMailer.sent_password(@user, password).deliver
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
      if @user.update_attributes(params[:user])
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
end
