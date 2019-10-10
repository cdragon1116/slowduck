class ChatroomsChannel < ApplicationCable::Channel
  def subscribed
    current_user.is_online
    current_user.chatrooms.each do |chatroom|
      stream_from "chatrooms:#{chatroom.id}"
    end
  end
  def unsubscribed
    current_user.is_offline
    stop_all_streams
  end
end
