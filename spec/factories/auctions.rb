# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auction do
    association :user, factory: :user
    title Faker::Company.bs
    details Faker::Lorem.sentence
    ends_on (Time.now + 20.days)
    reserve_price Faker::Number.number(4)
    current_price 999
  end
end
