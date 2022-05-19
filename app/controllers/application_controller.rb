class ApplicationController < ActionController::API
  # protect_from_forgery prepend: true
  # before_action :authenticate_user!
  
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
end
