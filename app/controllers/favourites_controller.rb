class FavouritesController < ApplicationController
  def create
    @favourite = Favourite.new(report_id: params[:report_id] ,user_id: current_user.id)
  end
end
