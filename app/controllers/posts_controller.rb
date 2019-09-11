class PostsController < ApplicationController
  def show
    @chatroom = Chatroom.find_by(id: params[:chatroom_id])
    @post = Post.find_by(id: params[:id])
  end
end
