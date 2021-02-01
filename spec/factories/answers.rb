FactoryBot.define do
  factory :answer do
    body { "MyText" }
    association :question
  end
end
