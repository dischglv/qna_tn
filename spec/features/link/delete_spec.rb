require 'rails_helper'

feature 'User can delete his link', %q{
  In order to correct mistakes
  As an author of question or answer
  I'd like to be able to delete link
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user, links_attributes: [{name: 'Google', url: 'google.com'}]) }
  given!(:answer) { create(:answer, question: question, user: user, links_attributes: [{name: 'Yandex', url: 'yandex.ru'}]) }

  scenario 'User can delete his link from question', js: true do
    sign_in user
    visit question_path(question)

    within '.question > .links' do
      click_on 'Delete link'

      expect(page).to_not have_link 'Google'
    end
  end

  scenario 'User can delete his link from answer', js: true do
    sign_in user
    visit question_path(question)

    within "#answer-#{answer.id}" do
      click_on 'Delete link'

      expect(page).to_not have_link 'Yandex'
    end
  end

  scenario "User can not delete other user's link", js: true do
    sign_in user2
    visit question_path(question)

    within ".question > .links" do
      expect(page).to_not have_link "Delete link"
    end
  end
end