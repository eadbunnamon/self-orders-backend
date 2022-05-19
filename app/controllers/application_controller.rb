class ApplicationController < ActionController::API
  # protect_from_forgery prepend: true
  before_action :authenticate_user!
  
  include Pundit::Authorization
end
