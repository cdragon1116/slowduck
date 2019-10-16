class ChatroomsController < ApplicationController
  before_action :authenticate_user!  
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy, :hide_chatroom]
  before_action :authenticate_chatroom_user! , only: [:show, :edit, :update, :destroy, :hide_chatroom]
  before_action :set_new_conversation, only: [:show, :new, :edit, :create]
  before_action :update_notification, only: [:show]
  layout 'index', only: [:index]

  def index 
  end

  def show
    current_user.is_online
    @messages = @chatroom.initialize_messages end

  def new
    @chatroom = Chatroom.new
    @friends = current_user.relative_users
  end

  def edit
    @chatroom_users = @chatroom.users.includes(image_attachment: :blob)
    @chatroom_user = ChatroomUser.new
  end

  def create
    @chatroom = Chatroom.new(chatroom_params)
    @chatroom.chatroom_users.build(user_id: current_user.id)
    if @chatroom.save
      redirect_to @chatroom, notice: '成功創建聊天室'
    else
      render :new
    end
  end

  def create_conversation
    @chatroom = Chatroom.new(chatroom_params)
    @chatroom.chatroom_users.build(user: current_user)
    users_id = @chatroom.chatroom_users.map(&:user_id)

    if @chatroom.save
      redirect_to @chatroom
    elsif Chatroom.conversation_between(users_id).present?
      @chatroom = Chatroom.conversation_chatroom(users_id)
      @chatroom.chatroom_users.show
      redirect_to chatroom_path(@chatroom)
    else
      redirect_to chatrooms_path
    end
  end

  def hide_chatroom
    @chatroom.update_display(current_user, false)
  end

  def update
    unless @chatroom.update(chatroom_params)
      redirect_to edit_chatroom_path, notice: '聊天室名稱不能為空白'
    end
  end

  def destroy
    if @chatroom.users.length == 1
      @chatroom.destroy
      redirect_to chatrooms_path, notice: '成功刪除聊天室'
    else
      @chatroom.chatroom_users.find_by(user: current_user).destroy
      redirect_to chatrooms_path, notice: '已退出聊天室!'
    end
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:id])
  end

  def chatroom_params
    params.require(:chatroom).permit(:name, :public, :room_type, chatroom_users_attributes: [:user_id])
  end

  def authenticate_chatroom_user!
    unless @chatroom.users.exists?(id: current_user.id)
      update_notification
      redirect_to chatrooms_url, notice: '你沒有權限!'
    end
  end

  def update_notification
    @chatroom.notifications_with_related.where(recipient_id: current_user.id).update(read_at: Time.zone.now)
  end

  def set_new_conversation
    @conversation = Chatroom.new
    @conversation.chatroom_users.build
  end
end
