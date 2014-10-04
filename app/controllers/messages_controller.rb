class MessagesController < ApplicationController
  def index
  end
  def create
    @message = {
      content: params[:content],
      time: Time.now.to_s(:ru_datetime)
    }
  end
end
