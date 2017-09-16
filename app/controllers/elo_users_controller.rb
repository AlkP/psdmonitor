class EloUsersController < ApplicationController
  def index
    @elo_users = EloUser.includes(:check_user_active).page(params[:page])
  end

end