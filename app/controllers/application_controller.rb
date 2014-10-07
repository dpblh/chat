class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  def set_popular_channels
    @popular_channels = Channel.where(:private_channel => false).order(created_at: :desc).limit 5
  end
end
