module V1
  class RestaurantsController < ApplicationController
    before_action :authenticate_request!

    def index
      authorize Restaurant

      @restaurant_types = policy_scope(Restaurant)
      render json: @restaurant_types
    end

    def create
      render json: {status: :ok}
    end
  end
end
