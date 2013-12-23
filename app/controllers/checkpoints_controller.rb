class CheckpointsController < BaseController
  before_filter :check_answers, only: [:edit]
  before_filter :build_comments, only: [:review]
  
  def index
    if current_user.is_leader?
      @review_checkpoints = Checkpoint.by_reviewer(current_user.id)
      @review_checkpoints = @review_checkpoints.paginate(page: params[:page],per_page: params[:per_page])
    end
    respond_to do |format|
      format.html
    end
  end

  def new
    params[:period] ||= CheckpointPeriod.first.try(:id)
    checkpoints = Checkpoint.by_periods(params[:period]) unless params[:period].nil?
    # Return users not create with periods
    if checkpoints.blank?
      @users = params[:period].nil? ? [] : User.reporters
    else
      @users = User.reporters.not_in(checkpoints.map(&:user_id))
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def review
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
 
  def update
    respond_to do |format|
      if @checkpoint.update_attributes(model_params)
        format.html { redirect_to @checkpoint, notice: t(:update_success, scope: [:views, :messages]) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @checkpoint.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :index, notice: t(:delete_failed, scope: [:views, :messages]) }
      end
    end
  end

  def ranking
    @q = Checkpoint.search params[:q]
    @checkpoints = @q.result.approve
    respond_to do |format|
      format.html
    end
  end

private
  def check_answers
    @checkpoint.build_checkpoint_answers
  end

  def ordering(search)
    if current_user.is_staff?
      current_user.checkpoints
    elsif current_user.is_leader?
      current_user.checkpoints
    elsif current_user.is_manager?
      current_user.is_hr? ? Checkpoint.all : Checkpoint.by_approve(current_user.id).order("id DESC")
    end
  end

  def build_comments
    @checkpoint = Checkpoint.find params[:id]
    if current_user.user_answer_comments.by_checkpoint(@checkpoint.checkpoint_answers.ids).empty?
      @checkpoint.build_checkpoint_comments(current_user.id)
    end
  end

  def model_params
    params.require(:checkpoint).permit(:checkpoint_period_id, :state_event, :ranking,
                                    checkpoint_answers_attributes: [:id, :checkpoint_question_id ,:content, :point, :_destroy, 
                                    user_answer_comments_attributes: [:id, :comment , :user_id, :_destroy]]) if params[:checkpoint]
  end
end
