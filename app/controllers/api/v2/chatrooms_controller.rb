class Api::V2::ChatroomsController < ApplicationController
  before_action :set_chatroom
  include ActionView::Helpers::SanitizeHelper

  def get_users
    query = params["query"] 
    @users = @chatroom.users.select{|user| user.username.include?(query)}
    respond_to do |format|
      format.json
    end
  end

  def get_tags
    query = params["query"]
    @tags = @chatroom.tags.select{|tag| tag.tagname.include?(query)}
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
    @chatroom = Chatroom.includes(:users, :messages => :tags).find_by(id: params[:id])
  end
end
