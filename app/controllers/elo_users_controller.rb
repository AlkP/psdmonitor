class EloUsersController < ApplicationController
  def index
    key, sort = cookies[:elo_users]&.downcase&.split('/')
    @elo_users = EloUser.includes(:inactive_users).page(params[:page])
    # cookies[:elo_users] = 'id/desc'
  end

end