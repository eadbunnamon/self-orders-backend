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

      # TODO, set to general first
      restaurant.restaurant_type = RestaurantType.active.first

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

    def show
      restaurant = Restaurant.find(params[:id])
      authorize restaurant, :show?

      render json: restaurant, status: :ok
    end

    def destroy
      restaurant = Restaurant.find(params[:id])
      authorize restaurant, :destroy?

      restaurant.active = false
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
        :restaurant_type_id, image_attributes: [ :id, :file ]
      )
    end
  end
end
