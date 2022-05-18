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
    description_en: 'Drink & Food'
  )

buffet = RestaurantType.find_or_create_by(
    type_name: 'บุฟเฟ่ต์ (Buffet)',
    type_name_en: 'Buffet',
    description: 'Self Service',
    description_en: 'Self Service'
  )

puts "=> Restaurant types have been added."

super_admin = Role.find_or_create_by(name: 'super_admin')
admin = Role.find_or_create_by(name: 'admin')
restaurant_admin = Role.find_or_create_by(name: 'restaurant_admin')

puts "=> Admin roles have been added."

super_admin_user = User.find_or_initialize_by(
  name: 'Super Admin',
  email: 'admin@example.com',
  confirmed_at: Time.now)
super_admin_user.password = 'Asdqwe123!'
super_admin_user.save
super_admin_user.roles << super_admin if super_admin_user.roles.pluck(:name).exclude?('super_admin')

restaurant_admin = User.find_or_initialize_by(
  name: 'restaurant_admin',
  email: 'restaurant_admin@example.com',
  confirmed_at: Time.now)
restaurant_admin.password = 'Asdqwe123!'
restaurant_admin.save
restaurant_admin.roles << restaurant_admin if super_admin_user.roles.pluck(:name).exclude?('restaurant_admin')
puts "=> Super Admin and Admin have been added."

