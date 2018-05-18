class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]
  before_action :set_new_access, only: [:edit]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    update_sort(controller_name) if params['sort'].present?
    user = policy_scope(User).all.sort_by_session(session[controller_name])
    @count = user.count
    @users = user.page(params[:page])
    authorize @users
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @user = User.new
    authorize @user
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user)
    end
  end

  def create
    user = User.create(user_params)
    authorize user
    if user.save
      redirect_to edit_user_path(user)
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def set_new_access
    @access = Access.new
  end
end
