class ChatroomsChannel < ApplicationCable::Channel
  def subscribed
    current_user.online!
    current_user.chatrooms.each do |chatroom|
      stream_from "chatrooms:#{chatroom.id}"
    end
  end
  def unsubscribed
    current_user.offline!
    stop_all_streams
  end
end
