require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of the question
  I'd like to be able to edit the question
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user can not edit the question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user', js: :true do
    scenario 'edits his question' do
      sign_in user
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Your question', with: 'Edited question'
        click_on 'Save'
        wait_for_ajax

        save_and_open_page
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors'
    scenario "can not edit other user's question"
  end
end
