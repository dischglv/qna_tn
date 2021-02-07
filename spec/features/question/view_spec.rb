require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to choose a question
  As a user of the system
  I'd like to view a list of questions
} do

  given!(:questions) { create_list(:question, 5) }


  scenario 'Authenticated user can view a list of questions' do
    user = create(:user)
    sign_in(user)

    visit questions_path
    questions.each { |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    }
  end

  scenario 'Unauthenticated user can view a list of questions' do
    visit questions_path
    questions.each { |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    }
  end
end
