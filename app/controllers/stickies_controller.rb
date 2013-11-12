class StickiesController < BaseController
  def create
    respond_to do |format|
      @sticky = Sticky.new(report_id: params[:report_id], user_id: params[:user_id])
      if @sticky.save
        format.js
      else
        format.js { render "errors"}
      end
    end
  end

  def destroy
    respond_to do |format|
      @sticky = Sticky.find(params[:id])
      if @sticky.destroy
        format.js
      else
        format.js { render "errors"}
      end
    end
  end
end
