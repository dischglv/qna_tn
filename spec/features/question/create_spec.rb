require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:new_user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Text of test question title'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question title'
      expect(page).to have_content 'Text of test question title'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Text of test question title'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    expect(page).to_not have_link 'Ask question'
  end

  scenario 'Another user sees new question', js: true do
    Capybara.using_session('user') do
      sign_in user
      visit questions_path
    end

    Capybara.using_session('new_user') do
      sign_in new_user
      visit questions_path
    end

    Capybara.using_session('user') do
      click_on 'Ask question'
      fill_in 'Title', with: 'New question'
      fill_in 'Body', with: 'new question body'
      click_on 'Ask'
    end

    Capybara.using_session('new_user') do
      expect(page).to have_content 'New question'
      expect(page).to have_content 'new question body'
    end
  end
end
