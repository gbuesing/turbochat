class UsersController < ApplicationController
  skip_before_action :require_current_user
  before_action :require_no_current_user, except: :destroy

  def new
  end

  def create
    @user = User.where(name: user_params[:name]).first_or_create!
    cookies.permanent.signed[:user_id] = @user.id
    redirect_to root_path
  end

  def destroy
    cookies.permanent.signed[:user_id] = nil
    redirect_to root_path
  end

  private
    def user_params
      params.require(:user).permit :name
    end
end
