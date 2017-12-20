class UserInformationsController < ApplicationController
  def index
    @user_informations = UserInformation.all
  end

  def show
    user_information = UserInformation.where("UNICODE = ?", '$user$' + params[:id])
    @name = user_information.where("CODE = '$exec$'")[0].nil? ? "" : user_information.where("CODE = '$exec$'")[0].VOL
    @email = user_information.where("CODE = '$execmail$'")[0].nil? ? "" : user_information.where("CODE = '$execmail$'")[0].VOL
    @elo_usr_protocol = EloUsrProtocol.where("USERID = ?", params[:id])
    # @elo_usr_errs = EloUsrErr.where("USERID = ?", params[:id])
  end
end