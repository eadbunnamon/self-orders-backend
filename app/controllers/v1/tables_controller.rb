module V1
  class TablesController < ApplicationController
    before_action :authenticate_request!

    def index
      authorize Table
      @tables = policy_scope(Table.where(restaurant_id: params[:restaurant_id]))
      render json: @tables
    end

    def create
      authorize :table, :create?
      amount = table_params[:amount].to_i

      if amount > 0
        error_messages = []
        Table.transaction do
          (1..amount).each do |a|
            name = "#{table_params[:name]} #{a}"
            table = Table.new(name: name)
            table.restaurant_id = params[:restaurant_id]

            unless table.save
              error_messages << table.errors.full_messages.join(', ')
            end
          end
          if error_messages.present?
            unprocessable_entity_error(error_messages.join(', '))
            raise ActiveRecord::Rollback
          end
        end
      else
        table = Table.new(table_params.except(:amount))
        table.restaurant_id = params[:restaurant_id]

        if table.save
          render json: table, status: :ok
        else
          error_message = table.errors.full_messages.join(', ')
          unprocessable_entity_error(error_message)
        end
      end
    end

    def update
      table = Table.find(params[:id])
      authorize table, :update?
      table.assign_attributes(table_params)

      if table.save
        render json: table, status: :ok
      else
        error_message = table.errors.full_messages.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    def show
      table = Table.find(params[:id])
      authorize table, :show?

      render json: table, status: :ok
    end

    def destroy
      table = Table.find(params[:id])
      authorize table, :destroy?

      # TODO cannot destroy if this table has been ordering
      if table.destroy
        render json: { success: true }, status: :ok
      else
        error_message = table.errors.full_messages.join(', ')
        unprocessable_entity_error(error_message)
      end
    end

    private

    def table_params
      params.require(:table).permit(:name, :amount)
    end
  end
end
