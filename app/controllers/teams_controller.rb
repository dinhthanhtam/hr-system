class TeamsController < BaseController
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

  def edit
    respond_to do |format|
      format.html
    end
  end

  def create
    respond_to do |format|
      if @team.save
        format.html { redirect_to group_teams_path, notice: "Create team successfully!" }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update_attributes(model_params)
        format.html { redirect_to url_for(action: :show), notice: "Update team successfully!" }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @team.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end

private
  def ordering(search)
    @group.teams
  end

  def create_object
    super
    @team = @group.teams.build(params[model_symbol])
  end
  
  def model_params
    params.require(:team).permit(:name) if params[:team]
  end
end
