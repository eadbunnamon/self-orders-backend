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

      valid, error_messages = validate_number_of_sub_options

      if valid && item.save
        save_image(item) if item_params[:image_file].present?
        render json: item, status: :ok
      else
        errors = error_messages + item.errors.full_messages
        error_message = errors.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    def update
      item = Item.find(params[:id])
      authorize item, :update?
      item.assign_attributes(item_params)

      valid, error_messages = validate_number_of_sub_options

      if valid && item.save
        save_image(item) if item_params[:image_file].present?
        render json: item, status: :ok
      else
        errors = error_messages + item.errors.full_messages
        error_message = errors.join(', ')
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

    def save_image(item)
      image = if item.image.present?
        image = item.image
      else
        image = Image.new(imageable: item)
      end
      image.file = item_params[:image_file]
      image.save!
    end

    def validate_number_of_sub_options
      valid = true
      error_messages = []
      return [valid, error_messages] if item_params[:options_attributes].blank?
      items = item_params[:options_attributes].reject { |s| s[:_destroy].present? }
      items.each do |option|
        sub_options = option[:sub_options_attributes].reject { |s| s[:_destroy].present? }
        if option[:need_to_choose].to_s == 'true'
          if option[:minimum_choose].to_i >= sub_options.count
            valid = false
            error_messages << 'ตัวเลือกต้องมีมากกว่าเลือกขั้นต่ำ'
          end
        else
          if sub_options.count == 0
            valid = false
            error_messages << 'At least 1 sub option'
          end
        end
      end
      [valid, error_messages]
    end

    def item_params
      params.require(:item).permit(
        :name, :name_en, :price, :image_file,
        options_attributes: [
          :id,
          :name,
          :name_en,
          :need_to_choose,
          :minimum_choose,
          :maximum_choose,
          :_destroy,
          sub_options_attributes: [
            :id,
            :name,
            :name_en,
            :additional_price,
            :_destroy
          ]
        ]
      )
    end
  end
end
