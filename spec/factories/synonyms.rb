FactoryBot.define do
  factory :synonym do
    reference { Faker::Lorem.unique.word }
    status { 0 }
    association :word, factory: :word
  end
end