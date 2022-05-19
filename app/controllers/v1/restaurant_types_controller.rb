module V1
  class RestaurantTypesController < ApplicationController
    before_action :authenticate_request!

    def index
      @restaurant_types = RestaurantType.all
      render json: @restaurant_types
    end
  end
end
