require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }


  describe 'POST #create' do
    describe 'Authenticated user' do
      before { login user }

      describe 'was not subscribed to the question' do
        it 'subscribes user to the question' do
          expect{ post :create, params: { question_id: question }, format: :js }.to change(user.subscriptions, :count).by(1)
        end
      end

      describe 'was subscribed to the question' do
        before { question.subscriptions.create(user_id: user.id) }
        it 'can not subscribe to the question' do
          expect{ post :create, params: { question_id: question }, format: :js }.to_not change(question.subscriptions, :count)
        end
      end
    end

    describe 'Auauthenticated user' do
      it 'can not subscribe to the question' do
        expect{ post :create, params: { question_id: question }, format: :js }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'Subscribed user' do
      before do
        login user
        question.subscriptions.create(user_id: user.id)
      end

      it 'deletes the subscription' do
        expect{ delete :destroy, params: { question_id: question, id: user.subscriptions.first } }.to change(user.subscriptions, :count).by(-1)
      end
    end
  end
end