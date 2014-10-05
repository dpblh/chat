module ApplicationHelper
  def tracked_channel
    if @channel
      '/messages/'+@channel.uid
    else
      '/messages/new'
    end
  end

  def tracked_pushing
    if @channel
      "/channels/#{@channel.id}/pushing"
    else
      '/messages/create'
    end
  end

  def private_channel_label(channel)
    if channel.private_channel
      'Приватный канал'
    else
      'Публичный канал'
    end
  end

  def show_link_subscribe(channel)
    link_to 'Подписаться', "/channels/#{channel.id}/subscribe" unless channel.author == @current_user or channel.subscriber.include?(@current_user)
  end
end
