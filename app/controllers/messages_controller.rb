class MessagesController < ApplicationController
  before_action :set_chatroom
  before_action :authenticate_user!
  def index
    render html:params
  end
  def show
    find_message
    @messages = @message.messages
  end
  def create
    message = Message.new(message_params)

    if message_params.has_key?("parent_id")
      message.save
      MessageRelayJob.perform_later(message)
    else
      message.save
      message.parent = message
      message.save
      MessageRelayJob.perform_later(message)
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
