require 'rails_helper'

feature 'User can view his awards', %q{
  As an authenticated user
  I'd like to be able to view all my awards
} do

  given!(:question) { create(:question) }
  given!(:user) { create(:user) }
  given(:award) { create(:award, question: question, user: user) }

  background { award.image.attach(io: File.open("#{Rails.root}/public/award_pic.jpeg"), filename: 'award_pic') }

  scenario 'User can view his awards' do
    sign_in user
    visit awards_index_path

    expect(page).to have_content award.title
    expect(page).to have_content 'award_pic'
    expect(page).to have_css 'img'
  end

end