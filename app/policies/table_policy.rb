class TablePolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.super_admin? || user.admin?
        scope.all
      else
        restaurant_ids = user.restaurants.pluck(:id)
        scope.where(restaurant_id: restaurant_ids)
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
    (user.restaurant_admin? && user.restaurants.pluck(:id).include?(record&.restaurant_id))
  end

  def show?
    update?
  end

  def destroy?
    update?
  end
end
