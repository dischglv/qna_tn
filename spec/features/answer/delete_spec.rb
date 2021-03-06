require 'rails_helper'

feature 'User can delete his answer', %q{
  As an author of the answer
  I'd like to be able to delete my own answer
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user1, question: question) }

  scenario 'Authenticated user can delete his own answer', js: true do
    sign_in(user1)
    visit question_path(question)

    expect(page).to have_content answer.body
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
    expect(current_path).to eql(question_path(question))
  end

  scenario "Authenticated user can not delete someone else's answer" do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Unauthenticated user can not delete answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end
end
