class RestaurantTypePolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.super_admin? || user.admin?
        scope.all
      else
        scope.where(active: true)
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
end
