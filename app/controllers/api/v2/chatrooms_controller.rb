class Api::V2::ChatroomsController < ApplicationController
  before_action :set_chatroom
  include ActionView::Helpers::SanitizeHelper
  def show_users
    query = params["query"] 
    @users = @chatroom.users.select{|user| user.username.include?(query)}
    respond_to do |format|
      format.json
    end
  end

  def show_tags
    query = params["query"]
    @tags = @chatroom.tags.select{|tag| tag.tagname.include?(query)}
    respond_to do |format|
      format.json
    end
  end

  def show_messages
    query = params["query"].split(" ").map{ |q| q.gsub(/[,]/,'')}
    if query and query.length > 0
      @messages = @chatroom.messages.select{ |message| 
        query.map{ |q| strip_tags(message.body).include?(q)}.count(true) == query.length
      }
    else
      @messages = []
    end
    respond_to do |format|
      format.json
    end
  end

  private
  def set_chatroom
    @chatroom = Chatroom.includes(:users, :messages => :tags).find_by(id: params[:id])
  end
end
