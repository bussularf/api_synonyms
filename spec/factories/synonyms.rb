FactoryBot.define do
  factory :synonym do
    reference { Faker::Lorem.unique.word }
    status { 1 }
  end
end