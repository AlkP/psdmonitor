class EloUsersController < ApplicationController
  def index
    @elo_users = EloUser.includes(:active_users).page(params[:page])
  end

end