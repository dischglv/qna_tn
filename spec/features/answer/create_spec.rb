require 'rails_helper'

feature 'User can answer a question', %q{
  As an authenticated user
  I'd like to be able to answer questions
} do

  given(:user) { create(:user) }
  given(:new_user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Answer body', with: 'answer body'
      click_on 'Answer'

      expect(current_path).to eql(question_path(question))
      within '.answers' do
        expect(page).to have_content 'answer body'
      end
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers the question with attached files' do
      fill_in 'Answer body', with: 'answer body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Another user sees new answer', js: true do
    Capybara.using_session('user') do
      sign_in user
      visit question_path(question)
    end

    Capybara.using_session('new_user') do
      sign_in new_user
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in 'Answer body', with: 'New answer'
      click_on 'Answer'
    end

    Capybara.using_session('new_user') do
      within '.answers' do
        expect(page).to have_content 'New answer'
      end
    end
  end
end
