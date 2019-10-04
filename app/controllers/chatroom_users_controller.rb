class ChatroomUsersController < ApplicationController
  before_action :set_chatroom
  def new
    @chatroom_users = @chatroom.users
    @chatroom_user = ChatroomUser.new
  end

  def create
    user_list = chatroom_user_params[:user][:email].split(" ")

    user_list.map{|user| user.strip}.each do |user|
      if User.find_by(email: user)
        @user = User.find_by(email: user) 
      else 
        @user = User.find_by(username: user)
      end
      if @user
        @chatroom.chatroom_users.where(user_id: @user).first_or_create
      end
    end
    redirect_to edit_chatroom_path(@chatroom.id)
  end

  def show
  end

  def destroy
    @chatroom_user = ChatroomUser.find_by(chatroom_id: @chatroom.id ,user_id: params[:id])
    if @chatroom.users.size == 1
      @chatroom_user.destroy
      @chatroom.destroy
    else
      @chatroom_user.destroy
      redirect_to edit_chatroom_path(@chatroom.id)  
    end
  end

  private
    def set_chatroom
      @chatroom = Chatroom.find(params[:chatroom_id])
    end
    def chatroom_user_params
      params.require(:chatroom_user).permit( user: [:email])
    end
    def find_admin
      ChatroomUser.find_by(chatroom_id: @chatroom.id ,admin: true).user
    end
end
