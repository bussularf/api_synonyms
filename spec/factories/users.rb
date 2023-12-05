FactoryBot.define do
  factory :user do
    username { 'admin' }
    email { 'admin@synonym.com' }
    password { '$dm!nhola123' }
    admin { true }
  end
end