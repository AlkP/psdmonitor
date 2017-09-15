class EloUsersController < ApplicationController
  def index
    @elo_users = EloUser.all
    @user_infromations = UserInformation.all
  end

end