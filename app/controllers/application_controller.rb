class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_current_user

  private
    def require_current_user
      redirect_to new_user_path unless current_user.present?
    end

    def require_no_current_user
      redirect_to root_path if current_user.present?
    end

    def current_user
      if cookies.signed[:user_id].present?
        @_current_user ||= User.find_by id: cookies.signed[:user_id]
      end
    end
    helper_method :current_user
end
