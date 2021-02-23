require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:google_url) { 'https://google.com/' }
  given(:yandex_url) { 'https://ya.ru' }

  scenario 'User adds link when asks question' do
    sign_in user
    visit new_question_path

    fill_in 'Title', with: 'New question title'
    fill_in 'Body', with: 'new question body text'

    fill_in 'Link name', with: 'Google site'
    fill_in 'Url', with: google_url

    click_on 'Ask'

    expect(page).to have_link 'Google site', href: google_url
  end

  scenario 'User adds several links when asks question', js: true do
    sign_in user
    visit new_question_path

    fill_in 'Title', with: 'New question title'
    fill_in 'Body', with: 'new question body text'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: google_url

    click_on 'Add link'

    within '.nested-fields:nth-of-type(2)' do
      fill_in 'Link name', with: 'Yandex'
      fill_in 'Url', with: yandex_url
    end

    click_on 'Ask'

    expect(page).to have_link 'Google', href: google_url
    expect(page).to have_link 'Yandex', href: yandex_url
  end

  scenario 'User adds link when asks answer', js: true do
    sign_in user
    visit question_path(question)

    fill_in 'Answer body', with: 'answer body'

    fill_in 'Link name', with: 'Google site'
    fill_in 'Url', with: google_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'Google site', href: google_url
    end
  end

  scenario 'User adds several links when asks answer', js: true do
    sign_in user
    visit question_path(question)

    fill_in 'Answer body', with: 'answer body'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: google_url

    click_on 'Add link'

    within '.nested-fields:nth-of-type(2)' do
      fill_in 'Link name', with: 'Yandex'
      fill_in 'Url', with: yandex_url
    end

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'Google', href: google_url
      expect(page).to have_link 'Yandex', href: yandex_url
    end
  end
end