# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# ---
# Clean up
# ---


ManagementClient.destroy_all
PropertyClient.destroy_all
AccountExecutive.destroy_all
Admin.destroy_all
User.destroy_all
Identity.destroy_all


# ---
# General users
# ---


# Create a registered user.
user = User.create!(
  name: "Example user"
)
Identity.create!(
  user:                  user,
  email:                 "user@example.com",
  password:              "password",
  password_confirmation: "password"
)


# ---
# General backend users
# ---


# Create a registered admin.
admin = Admin.create!(
  name: "Example admin"
)
Identity.create!(
  backend_user:          admin,
  email:                 "admin@example.com",
  password:              "password",
  password_confirmation: "password"
)


# Create a registered account_executive.
account_executive = AccountExecutive.create!(
  name: "Example account_executive"
)
Identity.create!(
  backend_user:          account_executive,
  email:                 "account_executive@example.com",
  password:              "password",
  password_confirmation: "password"
)


# Create a registered management_client that belongs to the account_executive.
management_client = account_executive.management_clients.create!(
  name: "Example management_client"
)
Identity.create!(
  backend_user:          management_client,
  email:                 "management_client@example.com",
  password:              "password",
  password_confirmation: "password"
)


# Create a registered property_client that belongs to the account_executive.
property_client = account_executive.property_clients.create!(
  name: "Example property_client"
)
Identity.create!(
  backend_user:          property_client,
  email:                 "property_client@example.com",
  password:              "password",
  password_confirmation: "password"
)


# ---
# Create Masa as an admin who has a facebook account.
# ---


masatoshi = Admin.create!(
  name: "Masatoshi"
)
Identity.create!(
  backend_user:          masatoshi,
  email:                 "nishiguchi.masa@gmail.com",
  password:              "password",
  password_confirmation: "password"
)
