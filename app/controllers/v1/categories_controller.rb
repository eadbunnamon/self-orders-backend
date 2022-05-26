module V1
  class CategoriesController < ApplicationController
    before_action :authenticate_request!

    def index
      authorize Category
      @categories = policy_scope(Category.where(restaurant_id: params[:restaurant_id]))
      render json: @categories
    end

    def create
      authorize :category, :create?
      category = Category.new(category_params)
      category.restaurant_id = params[:restaurant_id]

      if category.save
        render json: category, status: :ok
      else
        error_message = category.errors.full_messages.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    def update
      category = Category.find(params[:id])
      authorize category, :update?
      category.assign_attributes(category_params)

      if category.save
        render json: category, status: :ok
      else
        error_message = category.errors.full_messages.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    def show
      category = Category.find(params[:id])
      authorize category, :show?

      render json: category, status: :ok
    end

    def destroy
      category = Category.find(params[:id])
      authorize category, :destroy?

      # TODO cannot destroy if this category has been ordering
      if category.destroy
        render json: { success: true }, status: :ok
      else
        error_message = category.errors.full_messages.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    private

    def category_params
      params.require(:category).permit(:name, :name_en)
    end
  end
end
