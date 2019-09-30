class MessagesController < ApplicationController
  before_action :set_chatroom
  before_action :authenticate_user!
  include MessagesHelper

  def index
    render html:params
  end
  def show
    find_message
    @messages = @message.messages.order(created_at: :desc).reverse
  end

  def create
    message = Message.new(message_params)
    if message.save
      MessageRelayJob.perform_later(message)
    else
      redirect_to root_path, notice: "有問題"
    end
  end

  def destroy
  end
  private
    def set_chatroom
      @chatroom = Chatroom.friendly.find(params[:chatroom_id])
    end
    def message_params
      params.require(:message).permit(:body, :parent_id, :user_id, :chatroom_id)
    end
    def find_message
      @message = Message.friendly.find(params[:id])
    end
end
