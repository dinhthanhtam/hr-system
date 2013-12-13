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

  def destroy
    respond_to do |format|
      if @feedback.destroy
        format.html { redirect_to action: :index }
      else
        format { redirect_to action: :show }
      end
    end
  end

  def fixed
    feedback = Feedback.find(params[:id])
    feedback.set_fixed
    @id = params[:id]
    respond_to do |format|
      format.js
    end
  end

private
  def model_params
    params.require(:feedback).permit(:user_id, :title, :content) if params[:feedback]
  end
end
