class EloUsrErrsController < ApplicationController
  def index
    @elo_usr_errs = EloUsrErr.includes(:elo_user).page(params[:page])
  end

end