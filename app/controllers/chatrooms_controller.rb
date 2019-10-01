class ChatroomsController < ApplicationController
  before_action :authenticate_user! , except: [:index]
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy, :hide_chatroom]
  helper_method :find_admin
  skip_before_action :verify_authenticity_token, only: :create_one_on_one

  # GET /chatrooms
  def index
  end

  # GET /chatrooms/1
  # GET /chatrooms/1.json
  def show
    if @chatroom.users.exists?(id: current_user.id)
      @messages = @chatroom.messages.order(created_at: :desc).limit(10).reverse
    else
      redirect_to chatrooms_url, notice: "You don't have accessbility"
    end

  end

  # GET /chatrooms/new
  def new
    @chatroom = Chatroom.new
  end

  # GET /chatrooms/1/edit
  def edit
  end

  # POST /chatrooms
  # POST /chatrooms.json
  def create
    @chatroom = Chatroom.new(chatroom_params)
    
    respond_to do |format|
      if @chatroom.save and ChatroomUser.create(user_id:current_user.id, chatroom_id:@chatroom.id, admin:true)
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
    if current_user == message_user
      redirect_to chatroom_path(params[:chatroom_id]), notice:"不能對自己創建聊天室"
    elsif Conversation.between(current_user.id, message_user.id).present?
      @conversation = Conversation.between(current_user.id, message_user.id).first
      @chatroom = Chatroom.find_by(id: @conversation.chatroom_id) 
      @chatroom.chatroom_users.where(user_id:current_user.id).update(display: true)
      redirect_to chatroom_path(@chatroom), notice:"傳送到你跟#{message_user.username}對話"
    else 
      @chatroom = Chatroom.new(status:'1on1', name:"#{current_user.id}-#{message_user.id}")
      @chatroom.chatroom_users.update( user_id:current_user.id, display: true)
      @chatroom.users << [current_user, message_user]

      if @chatroom.save 
        Conversation.create(sender_id:current_user.id, receiver_id: message_user.id, chatroom_id: @chatroom.id )
        redirect_to chatroom_path(@chatroom), notice: "新創1-1對話"
      else
        redirect_to root_path , notice: "創建對話失敗"
      end
    end
        
  end
    
  def hide_chatroom
    @chatroom.chatroom_users.find_by(user_id:current_user.id).update(display:0)
    redirect_to root_path
  end

  # PATCH/PUT /chatrooms/1
  # PATCH/PUT /chatrooms/1.json
  def update
    respond_to do |format|
      if @chatroom.update(chatroom_params)
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully updated.' }
        format.json { render :show, status: :ok, location: @chatroom }
      else
        format.html { render :edit }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chatrooms/1
  # DELETE /chatrooms/1.json
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
    # Use callbacks to share common setup or constraints between actions.
    def set_chatroom
      @chatroom = Chatroom.includes(:messages).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chatroom_params
      params.require(:chatroom).permit(:name, :public, :status)
    end

end
