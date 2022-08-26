# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

general = RestaurantType.find_or_create_by(
    type_name: 'Bar & Restaurant',
    type_name_en: 'Bar & Restaurant',
    description: 'Drink & Food',
    description_en: 'Drink & Food',
    constant_type: 'general',
    active: true
  )

buffet = RestaurantType.find_or_create_by(
    type_name: 'บุฟเฟ่ต์ (Buffet)',
    type_name_en: 'Buffet',
    description: 'Self Service',
    description_en: 'Self Service',
    constant_type: 'buffet'
  )

puts "=> Restaurant types have been added."

super_admin = Role.find_or_create_by(name: 'super_admin')
admin = Role.find_or_create_by(name: 'admin')
restaurant_admin = Role.find_or_create_by(name: 'restaurant_admin')

puts "=> Admin roles have been added."

super_admin_user = User.find_or_initialize_by(
  username: 'super_admin',
  name: 'Super Admin',
  email: 'admin@example.com',
  confirmed_at: Time.now)
super_admin_user.password = 'Asdqwe123!'
super_admin_user.save
super_admin_user.roles << super_admin if super_admin_user.roles.pluck(:name).exclude?('super_admin')

restaurant_admin_user = User.find_or_initialize_by(
  username: 'restaurant_admin',
  name: 'restaurant_admin',
  email: 'restaurant_admin@example.com',
  confirmed_at: Time.now)
restaurant_admin_user.password = 'Asdqwe123!'
restaurant_admin_user.save
restaurant_admin_user.roles << restaurant_admin if restaurant_admin_user.roles.pluck(:name).exclude?('restaurant_admin')
puts "=> Super Admin and Admin have been added."

restaurant = Restaurant.find_or_initialize_by(
  name: 'ETNEE',
  name_en: 'ETNEE-EN',
  open_time: '08:00',
  close_time: '20:00',
  restaurant_type: general)
restaurant.save
restaurant.users << restaurant_admin_user if restaurant.users.pluck(:email).exclude?(restaurant_admin_user.email)
puts "=> Added restaurant"

table_1 = Table.find_or_create_by(name: "T1", restaurant: restaurant)
table_2 = Table.find_or_create_by(name: "T2", restaurant: restaurant)

category = Category.find_or_create_by(name: 'Drink', name_en: 'Drink', restaurant: restaurant)

item_1 = Item.find_or_create_by(name: 'Soda', name_en: 'Soda', price: 15, category: category)
item_2 = Item.find_or_create_by(name: 'Coke', name_en: 'Coke', price: 20, category: category)

option = Option.find_or_create_by(name: 'Size', name_en: 'Size', need_to_choose: true, maximum_choose: 1, item: item_1)

sub_option = SubOption.find_or_create_by(name: 'Normal', name_en: 'NormalX', option: option)

