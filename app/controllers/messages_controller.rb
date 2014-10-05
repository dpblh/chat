class MessagesController < ApplicationController
  before_action :set_current_user, except: [:show_login, :login]
  before_action :set_popular_channels, only: [:index, :show_login]

  def index
  end
  # temp
  def show_login

  end

  def login
    user = User.find_by_login params[:login]
    if user
      session[:current_user] = user.id
      redirect_to root_url, notice: 'Успешный вход в систему'
    else
      redirect_to messages_show_login_path, notice: 'Такой логин не существует'
    end
  end

  def logout
    session[:current_user] = nil
    redirect_to root_url
  end

  def create
    @message = {
      content: params[:content],
      time: Time.now.to_s(:ru_datetime),
      login: @current_user.login
    }
  end
end
