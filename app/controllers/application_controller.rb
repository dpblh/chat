class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  def set_popular_channels
    @popular_channels = Channel.where(:private_channel => false).order(created_at: :desc).limit 5
  end

  def send_message content
    @message = {
        content: content,
        time: Time.now.to_s(:ru_datetime),
        login: current_user.username
    }
    write_channel_log file_log, @message
  end

  def file_log
    if @channel
      "#{@channel.name}_#{@channel.uid}"
    else
      'common'
    end
  end

  def write_channel_log uid, message
    # ни фига не так надо.
    File.open(Rails.root.join('log/channels', uid+'.log'), 'a') {|f| f.puts message.to_json}
  end

end
