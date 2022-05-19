module V1
  class AuthenticationController < ApplicationController
    def authenticate_user
      command = ::Authentication.call(params[:email], params[:password])
      if command.success?
       render json: command.result
      else
       render json: command.errors, status: :unauthorized
      end
    end
  end
end
