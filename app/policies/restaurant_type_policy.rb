class RestaurantTypePolicy < ApplicationPolicy
  def index?
    user.super_admin? ||
    user.admin? ||
    user.restaurant_admin?
  end
end
