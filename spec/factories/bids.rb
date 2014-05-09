# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bid do
    association :user, factory: :user
    association :auction, factory: :auction
    price 10000
  end
end