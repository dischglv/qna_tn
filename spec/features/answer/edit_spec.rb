require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do

    scenario 'edits his answer' do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'My edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'My edited answer'
        expect(page).to_not have_selector 'textarea', visible: true
      end
    end

    scenario 'edits his answer with errors' do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in user2
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
