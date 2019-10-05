class ChatroomsController < ApplicationController
  before_action :authenticate_user! , except: [:index]
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy, :hide_chatroom]
  helper_method :find_admin
  skip_before_action :verify_authenticity_token, only: :create_one_on_one

  def index
  end

  def show
    update_visited_chatroom(@chatroom)
    if @chatroom.users.exists?(id: current_user.id)
      @messages = @chatroom.initialize_messages
      @chatroom_users_online = @chatroom.online_users.limit(10)
      @chatroom_users_offline = @chatroom.offline_users.limit(10)
    else
      redirect_to chatrooms_url, notice: "You don't have accessbility"
    end
  end

  def new
    @chatroom = Chatroom.new
    @friends = current_user.relative_users
  end

  def edit
    @chatroom_users = @chatroom.users
    @chatroom_user = ChatroomUser.new
  end

  def create
    @chatroom = Chatroom.new(chatroom_params)
    respond_to do |format|
      if @chatroom.save and ChatroomUser.create(user: current_user, chatroom: @chatroom, admin:true)
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully created.' }
        format.json { render :show, status: :created, location: @chatroom }
      else
        format.html { render :new }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
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
    if current_user.chatrooms.length > 0 
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
      @chatroom = Chatroom.includes(:messages, :users).find(params[:id])
    end

    def chatroom_params
      params.require(:chatroom).permit(:name, :public, :status)
    end

    def update_visited_chatroom(chatroom)
      unless chatroom.status == "1on1"
        current_user.update(last_visited_chatroom: chatroom.id)
      end
    end
end
