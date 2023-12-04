FactoryBot.define do
  factory :synonym do
    reference { Faker::Lorem.unique.word }
  end
end