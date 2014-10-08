require 'uuid'

class ChannelsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_channel, except: [:new, :create, :search]#: [:show, :edit, :update, :destroy, :chat, :pushing, :subscribe, :unsubscribe, :self_subscribe, :self_unsubscribe]
  before_action :only_owner, only: [:edit, :update, :destroy, :subscribe, :unsubscribe]
  before_action :set_popular_channels, only: [:chat, :show, :new, :edit, :search]
  before_action :is_signed, only: [:chat, :pushing]

  def chat
    render 'messages/index'
  end

  # Формируем и рендерим сообщение
  def pushing
    @message = {
        content: params[:content],
        time: Time.now.to_s(:ru_datetime),
        login: current_user.username
    }
    render 'messages/create'
  end

  def show
    # Показываем найденых пользователей
    @users = User.where(search_params.collect { |key, value| "upper(#{key}) like upper(?)" }.join(' and '), *search_params.collect{|key, value| "#{value}%"}).all
    @users = [] unless @users
  end

  # Пользователь сам себя подписал
  def self_subscribe
    redirect_to root_path, notice: 'Подписать на приватный канал может только автор канала' and return if @channel.private_channel
    redirect_to root_path, notice: 'Вы уже подписались на канал' and return if @channel.subscriber.include?(current_user)
    @channel.subscriber << current_user
    redirect_to root_path, notice: 'Вы успешно подписались на канал'
  end

  # Пользовате отписался
  def self_unsubscribe
    @channel.subscriber.delete(current_user)
    redirect_to root_path, notice: 'Вы отписались от канала'
  end

  # Владелиц канала подписывает на канал
  def subscribe
    subscriber = User.find params[:subscriber_id]
    redirect_to channel_path, notice: "Пользователь #{subscriber.username} уже подписан на канал" and return if @channel.subscriber.include?(subscriber)
    @channel.subscriber << subscriber
    redirect_to channel_path, notice: "Пользователь #{subscriber.username} успешно подписан на канал"
  end

  # Владелец канала удаляет с канала
  def unsubscribe
    subscriber = User.find params[:subscriber_id]
    @channel.subscriber.delete(subscriber)
    redirect_to channel_path, notice: "Пользователь #{subscriber.username} успешно удалён с канал"
  end

  def search
    @channels = Channel.where(name: params[:channel_name], private_channel: false).all
    @channels = [] unless @channels
  end

  def new
    @channel = Channel.new
  end

  def edit
  end

  def create
    @channel = Channel.new(channel_params)
    @channel.author = current_user
    @channel.uid= UUID.generate.to_s.gsub!('-', '')

    if @channel.save
      redirect_to @channel, notice: 'Канал успешно сохранен'
    else
      render :new
    end
  end

  def update
    if @channel.update(channel_params)
      redirect_to @channel, notice: 'Канал успешно обнавлен'
    else
      render :edit
    end
  end

  def destroy
    @channel.destroy
    redirect_to root_url, notice: 'Канал успешно удален'
  end

  private
    def set_channel
      @channel = Channel.find(params[:id])
    end

    def channel_params
      params.require(:channel).permit(:name, :uid, :private_channel)
    end

    def search_params
      temp = params.permit(:nickname, :first_name, :last_name, :provider)
      temp.select!{|key, value| !value.blank?}
      temp
    end

    def only_owner
      redirect_to root_url, notice: 'Этот канал вам не принадлежит' unless current_user.channels.include?(@channel)
    end

    def is_signed
      redirect_to root_path, notice: 'У вас нет доступа к каналу' unless @channel.author == current_user or @channel.subscriber.include?(current_user)
    end
end
