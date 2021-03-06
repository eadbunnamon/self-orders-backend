module V1
  class ItemsController < ApplicationController
    before_action :authenticate_request!

    def index
      authorize Item
      @items = policy_scope(Item.where(category_id: params[:category_id]))
      render json: @items
    end

    def create
      authorize :item, :create?
      item = Item.new(item_params)
      item.category_id = params[:category_id]

      valid, error_messages = Item.validate_options_data(item_params[:options_attributes])
      unless valid
        unprocessable_entity_error(error_messages.join(', '))
        return
      end

      if item.save
        render json: item, status: :ok
      else
        error_message = item.errors.full_messages.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    def update
      item = Item.find(params[:id])
      authorize item, :update?
      item.assign_attributes(item_params)

      valid, error_messages = Item.validate_options_data(item_params[:options_attributes])
      unless valid
        unprocessable_entity_error(error_messages.join(', '))
        return
      end

      if item.save
        render json: item, status: :ok
      else
        error_message = item.errors.full_messages.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    def show
      item = Item.find(params[:id])
      authorize item, :show?

      render json: item, status: :ok
    end

    def destroy
      item = Item.find(params[:id])
      authorize item, :destroy?

      # TODO cannot destroy if this item has been ordering
      if item.destroy
        render json: { success: true }, status: :ok
      else
        error_message = item.errors.full_messages.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    private

    def item_params
      params.require(:item).permit(
        :name, :name_en,
        image_attributes: [ :id, :file ],
        options_attributes: [ :id, :size, :price, :is_default, :_destroy]
      )
    end
  end
end
