FactoryBot.define do
  factory :word do
    reference { Faker::Lorem.unique.word }
    status { :approved }
  end
end