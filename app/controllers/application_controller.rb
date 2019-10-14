class ApplicationController < ActionController::Base
  before_action :current_user_chatrooms
  before_action :set_user
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private
  def record_not_found
    render :file => "#{Rails.root}/public/404.html",
          :status => 404,
          :layout => false
  end

  def current_user_chatrooms
    if user_signed_in?
      @group_chatrooms = current_user.group_chatrooms
      @conversations = current_user.conversations
      @notifications = current_user.notifications.includes(:notifiable, :actor).unread.order(created_at: :desc)
    else
      @group_chatrooms = []
      @conversations = []
      @notifications = []
    end
  end

  def set_user
    if current_user
      cookies["078asdf"] = current_user.id
    end
  end
end
