FactoryBot.define do

  factory :question do
    sequence :title do |n|
      "QuestionTitle#{n}"
    end
    sequence :body do |n|
      "QuestionBody#{n}"
    end
    user

    trait :invalid do
      title { nil }
    end
  end
end
