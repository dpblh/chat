class MessagesController < ApplicationController
  before_action :authenticate_user!, except: :show_login
  before_action :set_popular_channels, only: [:index, :show_login]

  def index
  end

  def create
    send_message params[:content]
  end
end
