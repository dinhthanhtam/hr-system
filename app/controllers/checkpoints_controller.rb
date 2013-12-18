class CheckpointsController < BaseController
  def new
    params[:period] ||= CheckpointPeriod.first.try(:id)
    checkpoints = Checkpoint.by_periods(params[:period]) unless params[:period].nil?
    # Return users not create with periods
    if checkpoints.blank?
      @users = params[:period].nil? ? [] : User.reporters
    else
      @users = User.reporters.not_in(checkpoints.map(&:user_id))
    end
    respond_to do |format|
      format.html
    end
  end

  def create
    # Create multiple checkpoint with each user_id
    unless params[:user_ids].blank?
      Checkpoint.create(params[:user_ids].map { |user_id| {user_id: user_id} }) do |checkpoint|
        checkpoint.checkpoint_period_id = params[:period]
        checkpoint.reviewer_id = params[:review]
        checkpoint.approve_id = params[:approve]
      end
    end

    respond_to do |format|
      format.html { redirect_to new_checkpoint_path(period: params[:period]) }
    end
  end
end
