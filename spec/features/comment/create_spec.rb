require 'rails_helper'

feature 'User can add a comment' do
  given(:user) { create(:user) }
  given(:new_user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can add a comment to the question' do
      within '.question .comment_form' do
        fill_in 'Your comment', with: 'new comment to the question'
        click_on 'Save'
      end

      within '.question .comments' do
        expect(page).to have_content 'new comment to the question'
      end
    end

    scenario 'can add a comment to the answer' do
      within '.answer .comment_form' do
        fill_in 'Your comment', with: 'new comment to the answer'
        click_on 'Save'
      end

      within '.answer .comments' do
        expect(page).to have_content 'new comment to the answer'
      end
    end
  end

  scenario 'another user sees new comment to the answer' do
    Capybara.using_session('user') do
      sign_in user
      visit question_path(question)
    end

    Capybara.using_session('new_user') do
      sign_in new_user
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within "#answer-#{answer.id}" do
        fill_in 'Your comment', with: 'new comment to the answer'
        click_on 'Save'
      end
    end

    Capybara.using_session('new_user') do
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'new comment to the answer'
      end
    end
  end

  scenario 'another user sees new comment to the answer' do
    Capybara.using_session('user') do
      sign_in user
      visit question_path(question)
    end

    Capybara.using_session('new_user') do
      sign_in new_user
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within ".question" do
        fill_in 'Your comment', with: 'new comment to the question'
        click_on 'Save'
      end
    end

    Capybara.using_session('new_user') do
      within ".question" do
        expect(page).to have_content 'new comment to the question'
      end
    end
  end
end