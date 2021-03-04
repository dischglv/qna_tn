require 'rails_helper'

feature 'User can vote for or against the question', %q{
  In order to show which question I like
  As an authenticated user
  I'd like to be able to vote for the question
} do

  let(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario "Authenticated user can vote for other user's question", js: true do
    sign_in user2
    visit question_path(question)

    within find('.question .votes__votes-for-count') do
      expect(page).to have_content '0'
    end

    within '.question .votes' do
      click_on 'Vote for'
    end

    within '.question .votes__votes-for-count' do
      expect(page).to have_content '1'
    end
  end

  scenario "Authenticated user can vote against other user's question", js: true do
    sign_in user2
    visit question_path(question)

    within find('.question .votes__votes-against-count') do
      expect(page).to have_content '0'
    end

    within '.question .votes' do
      click_on 'Vote against'
    end

    within '.question .votes__votes-against-count' do
      expect(page).to have_content '1'
    end
  end

  scenario "Authenticated user can not vote for/against his own question", js: true do
    sign_in user
    visit question_path(question)

    within '.question .votes' do
      click_on 'Vote for'

      expect(page).to have_content("Author can not vote or you should cancel your previous vote")
    end

    within '.question .votes' do
      click_on 'Vote against'

      expect(page).to have_content("Author can not vote or you should cancel your previous vote")
    end
  end

  scenario "User can vote for question only once", js: true do
    sign_in user2
    visit question_path(question)

    within '.question .votes' do
      click_on 'Vote for'
      click_on 'Vote for'

      expect(page).to have_content("Author can not vote or you should cancel your previous vote")
    end
  end

  scenario "User can vote against question only once", js: true do
    sign_in user2
    visit question_path(question)

    within '.question .votes' do
      click_on 'Vote against'
      click_on 'Vote against'

      expect(page).to have_content("Author can not vote or you should cancel your previous vote")
    end
  end

  scenario "User can cancel and re-vote", js: true do
    sign_in user2
    visit question_path(question)

    within '.question .votes' do
      click_on 'Vote for'
      click_on 'Cancel'
      click_on 'Vote against'
    end

    within '.question .votes__votes-against-count' do
      expect(page).to have_content '1'
    end
  end

  scenario "User can view rating of voting", js: true do
    sign_in user2
    visit question_path(question)

    within '.question .votes' do
      click_on 'Vote for'
      click_on 'Vote for'
      click_on 'Vote against'
    end

    within '.question .votes__rating' do
      expect(page).to have_content '1'
    end
  end

  scenario "Unauthenticated user can not vote", js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Vote for'
    expect(page).to_not have_link 'Vote against'
  end
end