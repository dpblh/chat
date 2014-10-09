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

end
