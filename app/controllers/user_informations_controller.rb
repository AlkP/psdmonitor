class UserInformationsController < ApplicationController
  def index
    @user_informations = UserInformation.all
  end

end