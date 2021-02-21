require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:google_url) { 'https://google.com/' }

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
end