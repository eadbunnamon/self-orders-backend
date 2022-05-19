module V1
  class RestaurantTypesController < ApplicationController
    def index
      @restaurant_types = RestaurantType.all
      render json: @restaurant_types
    end
  end
end
