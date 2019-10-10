class MessageRelayJob < ApplicationJob
  queue_as :default

  def perform(message, user)
    ActionCable.server.broadcast "chatrooms:#{message.chatroom_id}", {
      message:  ApplicationController.renderer.render(partial: 'messages/message', locals: {message: message, current_user: user}),
      username: message.user.username,
      body: message.body,
      chatroom_id: message.chatroom_id
    }
  end
end
