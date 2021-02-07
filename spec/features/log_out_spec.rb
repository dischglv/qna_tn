require 'rails_helper'

feature 'User can log out', %q{
  In order to sign in as a different user
  As an authenticated user
  I'd like to log out
} do

  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'Authenticated user can log out from /questions page' do
    visit questions_path
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Authenticated user can log out from question page' do
    question = create(:question)

    visit question_path(question)
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
