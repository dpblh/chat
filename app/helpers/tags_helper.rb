module TagsHelper
  def private_channel_label(channel)
    if channel.private_channel
      raw('<span class="label label-warning">Приватный</span> ' + channel.name)
    else
      raw('<span class="label label-success">Публичный</span> ' + channel.name)
    end
  end

  def show_link_subscribe(channel)
    link_to 'Подписаться', "/channels/#{channel.id}/subscribe" unless channel.author == current_user or channel.subscriber.include?(current_user)
  end

  def providers
    [['',''], %w(facebook facebook), %w(vkontakte vkontakte), %w(google_oauth2 google_oauth2)]
  end
end