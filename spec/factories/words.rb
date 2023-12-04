FactoryBot.define do
  factory :word do
    reference { Faker::Lorem.unique.word }
  end
end