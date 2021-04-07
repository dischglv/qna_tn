FactoryBot.define do
  factory :comment do
    body { 'body' }
    commentable { create(:question) }
  end
end
