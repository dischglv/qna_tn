FactoryBot.define do
  factory :vote do
    value { false }
    user
    votable { "" }
  end
end
