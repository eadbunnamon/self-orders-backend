class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :restaurants

  def super_admin?
    roles.pluck(:name).include?('super_admin')
  end

  def admin?
    roles.pluck(:name).include?('admin')
  end

  def restaurant_admin?
    roles.pluck(:name).include?('restaurant_admin')
  end
end
