class MessagesController < ApplicationController
  before_action :set_chatroom
  before_action :find_post
  def create
    message = Message.new(message_params)
    message.user = current_user
    message.chatroom_id = @chatroom.id
    @post.messages << message
    message.save
    redirect_to chatroom_post_path(@chatroom.id, @post.id)
  end

  def destroy
  end
  private
    def set_chatroom
      @chatroom = Chatroom.find(params[:chatroom_id])
    end
    def find_post
      @post = Post.find(params[:post_id])
    end
    def message_params
      params.require(:message).permit(:body)
    end
end
