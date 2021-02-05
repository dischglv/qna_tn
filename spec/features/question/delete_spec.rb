require 'rails_helper'

feature 'User can delete his question', %q{
  As an author of the question
  I'd like to be able to delete my own question
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { user1.questions.create(title: 'Question from user1', body: 'Question body') }

  scenario 'Authenticated user can delete his own question' do
    sign_in(user1)
    visit questions_path

    expect(page).to have_content question.title
    click_on 'Delete question'

    expect(page).to_not have_content question.title
  end

  scenario "Authenticated user can not delete someone else's question" do
    sign_in(user2)
    visit questions_path

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Unauthenticated user can not delete question' do
    visit questions_path
    expect(page).to_not have_link 'Delete question'
  end
end
