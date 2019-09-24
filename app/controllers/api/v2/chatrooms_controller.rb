class Api::V2::ChatroomsController < ApplicationController
  before_action :set_chatroom

  def show_users
    @users = @chatroom.users
    respond_to do |format|
      format.json
    end
  end

  def show_tags
    @tags = @chatroom.tags
    respond_to do |format|
      format.json
    end
  end

  private
  def set_chatroom
    @chatroom = Chatroom.find_by(id: params[:id])
  end
end
