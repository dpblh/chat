class MessagesController < ApplicationController
  before_action :authenticate_user!, except: :show_login
  before_action :set_popular_channels, only: [:index, :show_login]

  def index
  end

  def create
    @message = {
      content: params[:content],
      time: Time.now.to_s(:ru_datetime),
      login: current_user.username
    }
  end
end
