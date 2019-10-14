class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chatroom
  before_action :find_message, only: [:show]
  include MessagesHelper

  def index
    render html:params
  end
  def show
    @message.notifications.where(recipient_id: current_user.id ).update(read_at: Time.zone.now)
    @messages = @message.messages.includes(:user, :parent, :chatroom).order(created_at: :desc).reverse
  end

  def create
    message = Message.new(message_params)
    if message.save
      if message.chatroom.status == "1on1"
        message.chatroom.chatroom_users.update(display: true)
      end
        MessageRelayJob.perform_later(message, current_user)
    end
  end

  def destroy
  end
  private
    def set_chatroom
      @chatroom = Chatroom.find(params[:chatroom_id])
    end
    def message_params
      params.require(:message).permit(:body, :parent_id, :user_id, :chatroom_id)
    end
    def find_message
      @message = Message.find(params[:id])
    end
end
