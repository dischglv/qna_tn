require 'rails_helper'

feature 'User can subscribe to a question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background { sign_in user }

    describe 'Unsubscribed' do
      it 'can not see unsubscribe button' do
        visit question_path(question)
        expect(page).to_not have_link 'Unsubscribe'
      end

      it 'can subscribe to the question' do
        visit question_path(question)
        click_on 'Subscribe'
        visit question_path(question)

        expect(page).to have_content 'You have been subscribed to the question!'
      end
    end

    describe 'Subscribed' do
      background { question.subscriptions.create!(user_id: user.id) }

      it 'can not see subscribe button' do
        visit question_path(question)
        expect(page).to_not have_link 'Subscribe'
      end

      it 'can unsubscribe from the question' do
        visit question_path(question)
        click_on 'Unsubscribe'
        visit question_path(question)

        expect(page).to have_content 'You have been unsubscribed from the question!'
      end
    end
  end
end