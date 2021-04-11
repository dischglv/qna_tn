FactoryBot.define do
  factory :comment do
    body { 'body' }
    commentable { create(:question) }
    user
  end
end
