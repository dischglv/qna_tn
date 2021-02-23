require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:google_url) { 'https://google.com/' }

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
end