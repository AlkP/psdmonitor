class EloUsersController < ApplicationController
  def index
    update_sort(controller_name) if params['sort'].present?
    user = EloUser.all.sort_by_session(session[controller_name])
    @elo_users = user.includes(:inactive_users).page(params[:page])
  end

end