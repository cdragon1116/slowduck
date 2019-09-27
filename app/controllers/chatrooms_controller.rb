class ChatroomsController < ApplicationController
  before_action :authenticate_user! , except: [:index]
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy]
  helper_method :find_admin

  # GET /chatrooms
  def index
    if user_signed_in?
      @chatrooms = current_user.chatrooms
    else
      @chatrooms = []
    end
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
    if find_admin == current_user
      @chatroom.destroy
      respond_to do |format|
        format.html { redirect_to chatrooms_url, notice: 'Chatroom was successfully destroyed.' }
        format.json { head :no_content }
      end
    else 
      redirect_to chatroom_path(@chatroom), notice: 'You are not Chatroom admin!'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatroom
      @chatroom = Chatroom.includes(:messages).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chatroom_params
      params.require(:chatroom).permit(:name, :public)
    end

    def find_admin
      ChatroomUser.find_by(chatroom_id: @chatroom.id ,admin: true).user
    end
end
