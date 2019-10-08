class ChatroomsController < ApplicationController
  before_action :authenticate_user! , except: [:index]
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy, :hide_chatroom]
  before_action :authenticate_chatroom_user! , only: [:show, :edit, :update, :destroy, :hide_chatroom]
  skip_before_action :verify_authenticity_token, only: :create_one_on_one

  def index
  end
  def show
    current_user.is_online
    @chatroom.notifications.where(recipient_id: current_user.id ).update(read_at: Time.zone.now)
    @messages = @chatroom.initialize_messages
    @chatroom_users_online = @chatroom.online_users
    @chatroom_users_offline = @chatroom.offline_users
  end

  def new
    @chatroom = Chatroom.new
    @friends = current_user.relative_users
  end

  def edit
    @chatroom_users = @chatroom.users.includes(:image_attachment)
    @chatroom_user = ChatroomUser.new
  end

  def create
    @chatroom = Chatroom.new(chatroom_params)
    if @chatroom.save and ChatroomUser.create(user: current_user, chatroom: @chatroom, admin:true)
      redirect_to @chatroom, notice: '群組新增成功!'
    else
      render :new 
    end
  end

  def create_one_on_one
    message_user = User.find_by(id: params[:user_id])
    if Conversation.between(current_user.id, message_user.id).present?
      @conversation = Conversation.between(current_user.id, message_user.id).first
      @conversation.chatroom.update_display(current_user, true)
      redirect_to chatroom_path(@conversation.chatroom), notice:"傳送到你跟#{message_user.username}對話"
    else 
      @chatroom = Chatroom.new(status:'1on1', name:"#{current_user.id}-#{message_user.id}")
      @chatroom.users << [current_user, message_user]
      if @chatroom.save 
        @conversation = Conversation.create(sender_id: current_user.id, receiver_id: message_user.id, chatroom_id: @chatroom.id )
        @conversation.chatroom.update_display(current_user, true)
        redirect_to chatroom_path(@chatroom), notice: "新創1-1對話"
      else
        redirect_to root_path , notice: "創建對話失敗"
      end
    end
  end
    
  def hide_chatroom
    @chatroom.update_display(current_user, false)
    if current_user.group_chatrooms.length > 0 
      redirect_to chatroom_path( current_user.group_chatrooms.first )
    else
      redirect_to root_path
    end
  end

  def update
    unless @chatroom.update(chatroom_params)
      redirect_to edit_chatroom_path , notice: "聊天室名稱不能為空白"
    end
  end

  def destroy
    if @chatroom.users.length == 1
      @chatroom.destroy
      redirect_to root_path, notice: '成功刪除聊天室'
    else 
      @chatroom.chatroom_users.find_by(user_id: current_user.id).destroy
      redirect_to root_path, notice: '已退出聊天室!'
    end
  end

  private
    def set_chatroom
      @chatroom = Chatroom.find(params[:id])
    end

    def chatroom_params
      params.require(:chatroom).permit(:name, :public, :status)
    end

    def update_visited_chatroom(chatroom)
      unless chatroom.status == "1on1"
        current_user.update(last_visited_chatroom: chatroom.id)
      end
    end

    def authenticate_chatroom_user!
      unless @chatroom.users.exists?(id: current_user.id)
        redirect_to chatrooms_url, notice: "你沒有權限!"
      end
    end

end
