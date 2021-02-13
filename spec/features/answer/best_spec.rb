require 'rails_helper'

feature 'Author of the question can choose the best answer', %q{
  As an author of the question
  I'd like to be able to choose best answer
} do
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given!(:best_answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do

    scenario 'author of the question can choose best answer' do
      sign_in author
      visit question_path(question)

      within "#answer-#{best_answer.id}" do
        click_on 'Choose as best'
      end

      within find('.answers li', match: :first) do
        expect(page).to have_content best_answer.body
      end
    end

    scenario 'author of the question can choose new best answer' do
      previous_best_answer = create(:answer, question: question, best: true)

      sign_in author
      visit question_path(question)

      within find('.answers li', match: :first) do
        expect(page).to have_content previous_best_answer.body
      end

      within "#answer-#{best_answer.id}" do
        click_on 'Choose as best'
      end

      within find('.answers li', match: :first) do
        expect(page).to have_content best_answer.body
      end
    end

    scenario 'non-author of the question can not choose best answer' do
      user = create(:user)
      visit question_path(question)

      expect(page).to_not have_link 'Choose as best'
    end
  end

  scenario 'Unauthenticated user can not choose best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Choose as best'
  end
end
