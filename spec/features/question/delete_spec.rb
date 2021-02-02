require 'rails_helper'

feature 'User can delete his question', %q{
  As an author of the question
  I'd like to be able to delete my own question
} do
  scenario 'Authenticated user can delete his own question' do
    user1 = create(:user)
    user2 = create(:user)
    question = user1.questions.create(title: 'Question of user1', body: 'Body')

    sign_in(user1)
    visit questions_path
    click_on 'Delete question'

    expect(page).to_not have_content question.title
  end
  scenario "Authenticated user can not delete someone else's question"
  scenario 'Unauthenticated user can not delete question'
end
