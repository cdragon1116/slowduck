class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notifications

  def index
  end

  def mark_as_read
    if params[:id]
      @notification = Notification.find(params[:id])
      @notification.update_attribute(:read_at, Time.zone.now)
    else
      @notifications.update(read_at: Time.zone.now)
    end
    respond_to do |format|
      format.js
      format.json { render json: { success: true } }
    end
  end

  private

  def set_notifications
    @notifications = Notification.where(recipient: current_user).unread
  end

end
