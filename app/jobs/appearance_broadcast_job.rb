class AppearanceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.chatrooms.each do |chatroom|
      ActionCable.server.broadcast "appearance_#{chatroom.id}", render_user(user)
    end
  end

  private

  def render_user(user)
    ApplicationController.renderer.render(partial: 'shared/user_info', locals: {user: user})
  end
end
