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

    scenario 'edits his answer with attachments' do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'My edited answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'deletes his attachments' do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')

      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Delete file'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario "tries to delete other user's attachment" do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')

      sign_in user2
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Delete file'
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
