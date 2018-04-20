class UserInformationsController < ApplicationController
  def index
    @user_informations = UserInformation.all
  end

  def show
    @id = params[:id]
    @elo_usr_protocol = EloUsrProtocol.where("USERID = ?", params[:id])
  end
end