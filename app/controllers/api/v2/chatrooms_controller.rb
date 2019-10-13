class Api::V2::ChatroomsController < ApplicationController
  before_action :set_chatroom
  before_action :set_new_conversation, only: [:get_messages, :next_messages]
  include ActionView::Helpers::SanitizeHelper
  
  def get_relative_users
    query = params["query"]
    @users = current_user.relative_users
    respond_to do |format|
      format.json
    end
  end

  def get_users
    query = params["query"] 
    @users = @chatroom.users
    respond_to do |format|
      format.json
    end
  end

  def get_tags
    query = params["query"]
    @tags = @chatroom.tags
    respond_to do |format|
      format.json
    end
  end

  def get_messages
    query = params["query"].split(" ").map{ |q| q.gsub(/[,]/,'')}
    if query and query.length > 0
      @messages = @chatroom.messages.order(created_at: :desc).select{ |message| 
        query.map{ |q| strip_tags(message.body).include?(q)}.count(true) == query.length
      }
    else
      @messages = []
    end
    respond_to do |format|
      format.json
    end
  end
  
  def next_messages
    pre_id = params["pre_id"]
    @messages = @chatroom.messages.where('id < ?', pre_id).order(created_at: :desc).limit(5).reverse
    respond_to do |format|
      format.json
    end
  end

  private
  def set_chatroom
    @chatroom = Chatroom.find_by(id: params[:id])
  end
  def set_new_conversation
    @conversation = Chatroom.new
    @conversation.chatroom_users.build
  end
end
