require 'rails_helper'

feature 'User can add award for the best answer', %q{
  In order to appreciate the best answer
  As an author of the question
  I'd like to be able to create awards for the best answer
} do

  given(:user) { create(:user) }

  scenario 'User adds award when asks a question' do
    sign_in user
    visit new_question_path

    fill_in 'Title', with: 'Question with an award'
    fill_in 'Body', with: 'Some text'

    fill_in 'Award title', with: 'Cool award'
    attach_file 'Award image', "#{Rails.root}/public/award_pic.jpeg"

    click_on 'Ask'

    expect(page).to have_content 'Cool award'
    expect(page).to have_css 'img'
  end
end