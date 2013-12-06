class FeedbacksController < BaseController
  def index
  end

  def create
    respond_to do |format|
      if @success = @feedback.save
        format.js
      else
        format.js
      end
    end
  end

private
  def model_params
    params.require(:feedback).permit(:user_id, :title, :content) if params[:feedback]
  end
end
