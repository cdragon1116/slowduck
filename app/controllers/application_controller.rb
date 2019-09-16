class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :image])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :image])
    end

  private
    def record_not_found
     render :file => "#{Rails.root}/public/404.html", 
            :status => 404, 
            :layout => false 
    end
end
