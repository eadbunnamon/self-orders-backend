class ItemPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.super_admin? || user.admin?
        scope.all
      else
        return scope.none if user.restaurants.blank?
        category_ids = []
        user.restaurants.each do |restaurant|
          next if restaurant.categories.blank?
          restaurant.categories.each do |category|
            category_ids << category.id
          end
        end
        scope.where(category_id: category_ids)
      end
    end

    private

    attr_reader :user, :scope
  end

  def index?
    user.super_admin? ||
    user.admin? ||
    user.restaurant_admin?
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def update?
    user.super_admin? ||
    user.admin? ||
    (user.restaurant_admin? && user.restaurants.pluck(:id).include?(record&.category&.restaurant_id))
  end

  def show?
    update?
  end

  def destroy?
    update?
  end
end
