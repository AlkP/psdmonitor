class UsersController < ApplicationController
  def index
    update_sort(controller_name) if params['sort'].present?
    user = User.all.sort_by_session(session[controller_name])
    @count = user.count
    @users = user.page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end
end
