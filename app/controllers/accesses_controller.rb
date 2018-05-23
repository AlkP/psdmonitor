class AccessesController < ApplicationController
  before_action :set_user

  after_action :verify_authorized

  def create
    authorize @user
    access = @user.accesses.new(role: params[:role].to_i)
    access.save
    @access = Access.new
  end

  def destroy
    a =  @user.accesses.find(params[:id])
    authorize a
    a.destroy
    @access = Access.new
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
