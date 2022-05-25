class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  # protect_from_forgery prepend: true
  
  include Pundit::Authorization

  attr_reader :loged_in_user

  protected

  def authenticate_request!
    @loged_in_user = AuthorizeRequest.call(request.headers).result

    if @loged_in_user.blank?
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_user
    if loged_in_user.present?
      loged_in_user
    else
      nil
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:username, :email)
    end

    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
    user_params.permit({ roles: [] }, :email, :username, :password, :password_confirmation)
  end
  end

  private
  
  def unprocessable_entity_error(message)
    render json: {
      success: false,
      error: {
        message: message
      }
    }, status: :unprocessable_entity
  end

  def render_error(code, message)
    render json: {
      success: false,
      error: { message: message }
    }, status: code
  end

  def user_not_authorized
    render json: {
      success: false,
      error: { message: "You are not authorized to perform this action." }
    }, status: 401
  end
end
