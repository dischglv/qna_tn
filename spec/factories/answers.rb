FactoryBot.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body
    best { false }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
