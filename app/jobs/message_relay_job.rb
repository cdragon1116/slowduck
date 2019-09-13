class MessageRelayJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "chatrooms:#{message.chatroom_id}", {
      message: MessagesController.render(message),
      username: message.user.username,
      body: message.body,
      chatroom_id: message.chatroom_id
    }
  end
end
