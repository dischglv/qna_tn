require 'rails_helper'

feature 'User can answer a question', %q{
  As an authenticated user
  I'd like to be able to answer questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Answer body', with: 'answer body'

      click_on 'Answer'
      expect(page).to have_content 'Your answer successfully created'
      expect(page).to have_content 'answer body'
      expect(current_path).to eql(question_path(question))
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question'
end