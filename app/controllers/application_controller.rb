class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to messages_show_login_url, :notice => 'Вам нужно пройти авторизацию'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end

  def set_popular_channels
    @popular_channels = Channel.where(:private_channel => false).order(created_at: :desc).limit 5
  end
end
