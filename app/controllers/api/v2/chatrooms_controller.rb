class Api::V2::ChatroomsController < ApplicationController
  before_action :set_chatroom
  include ActionView::Helpers::SanitizeHelper
  def show_users
    query = params["query"] 
    if query
      @users = @chatroom.users.select{|user| user.username.include?(query)}
    else
      @users = @chatroom.users
    end
    respond_to do |format|
      format.json
    end
  end

  def show_tags
    query = params["query"] 
    if query
      @tags = @chatroom.messages.map{|message| message.tags}.flatten.uniq.select{|tag| tag.tagname.include?(query)}
    else
      @tags = @chatroom.messages.map{|x| x.tags}.flatten.uniq
    end
    respond_to do |format|
      format.json
    end
  end

  def show_messages
    query = params["query"]
    if query and query.strip.length > 0
      @messages = @chatroom.messages.select{ |message| strip_tags(message.body).include?(query.strip.gsub(',',''))}
    else
      @messages = []
    end
    respond_to do |format|
      format.json
    end
  end

  private
  def set_chatroom
    @chatroom = Chatroom.includes(:messages => :tags).find_by(id: params[:id])
  end
end
