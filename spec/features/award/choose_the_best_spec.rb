require 'rails_helper'

feature 'Author of the question rewards user', %q{
  In order to reward user for the best answer
  As an author of the question
  I'd like to be able to give the award to user
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:award) { create(:award, question: question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given!(:best_answer) { create(:answer, question: question, user: user) }

  background { award.image.attach(io: File.open("#{Rails.root}/public/award_pic.jpeg"), filename: 'award_pic.jpeg') }

  scenario 'Author rewards user for the best answer', js: true do
    sign_in author
    visit question_path(question)

    within "#answer-#{best_answer.id}" do
      click_on 'Choose as best'
    end

    within find('.answers li', match: :first) do
      expect(page).to have_content 'AWARDED'
    end
  end
end