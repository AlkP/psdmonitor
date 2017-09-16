class UserInformationsController < ApplicationController
  def index
    @user_informations = UserInformation.all
  end

  def show
    user_information = UserInformation.where("UNICODE = ?", '$user$' + params[:id].to_s)
    @name = user_information.where("CODE = '$exec$'")[0].VOL
    @email = user_information.where("CODE = '$execmail$'")[0].VOL
    @user = EloUser.find(params[:id].to_s)
  end
end