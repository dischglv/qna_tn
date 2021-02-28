FactoryBot.define do
  factory :question_link do
    name { "MyString" }
    url { "MyString" }
    association :linkable, factory: :question
  end

  factory :answer_link do
    name { "MyString" }
    url { "MyString" }
    association :linkable, factory: :answer
  end
end
