class ChatroomUsersController < ApplicationController
  before_action :set_chatroom

  def new
    @chatroom_user = ChatroomUser.new
    @chatroom_users = @chatroom.users
  end

  def create
    users_list = scan_users(chatroom_user_params[:user][:email])
    @chatroom.add_list_users(users_list, current_user)
    redirect_to edit_chatroom_path(@chatroom)
  end

  def show
  end

  def destroy
    @chatroom_user = ChatroomUser.find_by(chatroom: @chatroom, user_id: params[:id])
    if @chatroom.last_person?
      @chatroom.destroy
      redirect_to root_path
    else
      @chatroom_user.destroy
      @chatroom.notifications.create(recipient: @chatroom_user.user, actor: current_user, action: 'kickout')
      redirect_to edit_chatroom_path(@chatroom)
    end
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:chatroom_id])
  end

  def chatroom_user_params
    params.require(:chatroom_user).permit(user: [:email])
  end

  def scan_users(string)
    string.split(' ').map{ |user| user.strip }
  end
end
