class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
    def set_current_user
      user_id = session[:current_user]
      @current_user = User.find_by_id(user_id)
      redirect_to messages_show_login_url unless @current_user
    end

    def set_popular_channels
      @popular_channels = Channel.where(:private_channel => false).order(created_at: :desc).limit 5
    end
end
