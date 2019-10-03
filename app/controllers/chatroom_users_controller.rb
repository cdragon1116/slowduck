class ChatroomUsersController < ApplicationController
  before_action :set_chatroom
  def new
    @chatroom_users = @chatroom.users
    @chatroom_user = ChatroomUser.new
  end

  def create
    @user_email = chatroom_user_params[:user][:email]
    if @user = User.find_by(email: @user_email)
      @chatroom.chatroom_users.where(user_id: @user).first_or_create
      redirect_to edit_chatroom_path(@chatroom.id)
    else 
      redirect_to edit_chatroom_path(@chatroom.id), notice: "沒有此用戶"
    end
  end

  def show
  end

  def destroy
    if find_admin != current_user
      redirect_to edit_chatroom_path(@chatroom.id) , notice:"You're not admin"
    else
      @chatroom_user = ChatroomUser.find_by(chatroom_id: @chatroom.id ,user_id: params[:id])
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
