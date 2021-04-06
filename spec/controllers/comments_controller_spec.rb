require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { login user }

      it 'adds a new comment to the question' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'adds a new comment to the answer' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question, answer_id: answer }, format: :js }.to change(answer.comments, :count).by(1)
      end
    end
  end
end