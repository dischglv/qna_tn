require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an authenticated user
  I'd like to be able to sign up
} do

  scenario 'Unregistered user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registrated user tries to sign up' do
    user = create(:user)
    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
