class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { head :forbidden }
      format.json { render json: ['Votes is invalid'].to_json, status: :forbidden }
    end

  end

  check_authorization unless: :devise_controller?
end
