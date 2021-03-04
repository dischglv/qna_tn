FactoryBot.define do
  factory :vote do
    value { false }
    user { nil }
    votable { "" }
  end
end
