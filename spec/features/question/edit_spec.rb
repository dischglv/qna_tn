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

        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      sign_in user
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Your question', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'edits his question with attached files' do
      sign_in user
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Your question', with: 'Edited question'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario "can not edit other user's question" do
      sign_in user2
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
