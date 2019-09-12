class PostsController < ApplicationController
  before_action :set_chatroom
  def show
    @chatroom = Chatroom.find_by(id: params[:chatroom_id])
    @post = Post.find_by(id: params[:id])
    @messages = @post.messages.order(created_at: :desc).limit(50).reverse
  end
  def create

    @post = Post.create(user_id: current_user.id, chatroom_id: @chatroom.id)
    message = @post.messages.new(post_params)
    message.user = current_user
    message.head = true
    message.chatroom_id = @chatroom.id
    message.save
    MessageRelayJob.perform_later(message)
  end

  private
    def set_chatroom
      @chatroom = Chatroom.find(params[:chatroom_id])
    end
    def post_params
      params.require(:post).permit(:body)
    end
end
