class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_new_conversation, only: [:show]
  before_action :find_message, only: [:show, :update]

  def index
  end

  def update
    @message.update(message_params)
    MessageRelayJob.perform_later(@message, current_user)
  end

  def show
    @messages = @message.initialize_messages
  end

  def create
    message = Message.new(message_params)
    if message.save
      message.chatroom.chatroom_users.update(display: true)
      MessageRelayJob.perform_later(message, current_user)
    end
  end

  def destroy
  end

  private

  def message_params
    params.require(:message).permit(:body, :parent_id, :user_id, :chatroom_id)
  end

  def find_message
    @message = Message.find(params[:id])
  end

  def set_new_conversation
    @conversation = Chatroom.new
    @conversation.chatroom_users.build
  end
end
