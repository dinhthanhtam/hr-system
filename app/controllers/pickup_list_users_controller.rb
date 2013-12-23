class PickupListUsersController < BaseController
  def index
    respond_to do |format|
      format.html
    end
  end

  def destroy
    respond_to do |format|
      if @pickup_list_user.destroy
        format.html { redirect_to :back }
      else
        format { redirect_to action: :edit }
      end
    end
  end

private
  def load_objects
    @pickup_list_users = @pickup_list.pickup_list_users
  end

  def create_object
    super
    @pickup_list_user = @pickup_list.pickup_list_users.build(model_params)
  end

  def model_params
    params.require(:pickup_list_user).permit PickupListUser.updatable_attrs if params[:pickup_list_user]
  end
end