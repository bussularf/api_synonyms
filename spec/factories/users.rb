FactoryBot.define do
  factory :user do
    name { 'admin' }
    email { 'admin@synonym.com' }
    password { '$dm!nhola123' }
  end
end