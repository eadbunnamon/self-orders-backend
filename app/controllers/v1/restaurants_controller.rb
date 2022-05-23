module V1
  class RestaurantsController < ApplicationController
    before_action :authenticate_request!

    def index
      authorize Restaurant

      @restaurants = policy_scope(Restaurant)
      render json: @restaurants
    end

    def create
      authorize :restaurant, :create?
      restaurant = Restaurant.new(restaurant_params)

      if restaurant.save
        render json: restaurant, status: :ok
      else
        error_message = restaurant.errors.full_messages.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    def update
      restaurant = Restaurant.find(params[:id])
      restaurant.assign_attributes(restaurant_params)
      authorize restaurant, :update?

      if restaurant.save
        render json: restaurant, status: :ok
      else
        error_message = restaurant.errors.full_messages.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    private

    def restaurant_params
      params.require(:restaurant).permit(
        :name, :name_en, :open_time, :close_time,
        :day_off_description, :day_off_description_en,
        :restaurant_type_id
      )
    end
  end
end
