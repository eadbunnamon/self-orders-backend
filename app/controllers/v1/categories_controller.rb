module V1
  class CategoriesController < ApplicationController
    before_action :authenticate_request!

    def index
      authorize Category
      @categories = policy_scope(Category.where(restaurant_id: params[:restaurant_id]))
      render json: @categories
    end
  end
end
