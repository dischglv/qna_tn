FactoryBot.define do
  factory :question_link, class: Link do
    name { "MyString" }
    url { "https://google.com" }
    association :linkable, factory: :question
  end

  factory :answer_link, class: Link do
    name { "MyString" }
    url { "https://google.com" }
    association :linkable, factory: :answer
  end
end
