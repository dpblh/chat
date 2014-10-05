require 'uuid'

class ChannelsController < ApplicationController
  before_action :set_channel, only: [:show, :edit, :update, :destroy, :chat, :pushing, :subscribe, :unsubscribe, :self_subscribe, :self_unsubscribe]
  before_action :set_current_user
  before_action :only_owner, only: [:edit, :update, :destroy, :subscribe]
  before_action :set_popular_channels, only: [:chat, :show, :new, :edit]
  before_action :is_signed, only: :chat

  def chat
    render 'messages/index'
  end

  def pushing
    @message = {
        content: params[:content],
        time: Time.now.to_s(:ru_datetime),
        login: @current_user.login
    }
    render 'messages/create'
  end

  def show
    @users = User.where(login: params[:login])
    @users = [] unless @users
  end

  def self_subscribe
    redirect_to root_path, notice: 'Подписать на приватный канал может только автор канала' and return if @channel.private_channel
    redirect_to root_path, notice: 'Вы уже подписались на канал' and return if @channel.subscriber.include?(@current_user)
    @channel.subscriber << @current_user
    redirect_to root_path, notice: 'Вы успешно подписались на канал'
  end

  def self_unsubscribe
    @channel.subscriber.delete(@current_user)
    redirect_to root_path, notice: 'Вы отписались от канала'
  end

  def subscribe
    subscriber = User.find params[:subscriber_id]
    redirect_to channel_path, notice: "Пользователь #{subscriber.login} уже подписан на канал" and return if @channel.subscriber.include?(subscriber)
    @channel.subscriber << subscriber
    redirect_to channel_path, notice: "Пользователь #{subscriber.login} успешно подписан на канал"
  end

  def unsubscribe
    subscriber = User.find params[:subscriber_id]
    @channel.subscriber.delete(subscriber)
    redirect_to channel_path, notice: "Пользователь #{subscriber.login} успешно удалён с канал"
  end

  def new
    @channel = Channel.new
  end

  def edit
  end

  def create
    @channel = Channel.new(channel_params)
    @channel.author = @current_user
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
    redirect_to channels_url, notice: 'Канал успешно удален'
  end

  private
    def set_channel
      @channel = Channel.find(params[:id])
    end

    def channel_params
      params.require(:channel).permit(:name, :uid, :private_channel)
    end

    def only_owner
      redirect_to root_url, notice: 'Этот канал вам не принадлежит' unless @current_user.channels.include?(@channel)
    end

    def is_signed
      redirect_to root_path, notice: 'У вас нет доступа к каналу' unless @channel.author == @current_user or @channel.subscriber.include?(@current_user)
    end
end
