class MessageRelayJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "chatrooms:#{message.chatroom_id}", {
      message:  ApplicationController.renderer.render(partial: 'messages/message_broadcast', locals: {message: message}),
      username: message.user.username,
      body: message.body,
      chatroom_id: message.chatroom_id,
      message_id: message.id,
    }
  end
end
