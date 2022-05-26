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
        category_ids = user.restaurants.map { |r| r.categories.pluck(:id) }.compact
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
