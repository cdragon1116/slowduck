class MessagesController < ApplicationController
  before_action :set_chatroom
  def create
    @post = Post.create(user_id: current_user.id, chatroom_id: @chatroom.id)
    message = @post.messages.new(message_params)
    message.user = current_user
    message.save
    redirect_to @chatroom
  end

  def destroy
  end
  private
    def set_chatroom
      @chatroom = Chatroom.find(params[:chatroom_id])
    end
    def message_params
      params.require(:message).permit(:body)
    end
end
