require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  describe 'GET #show' do
    let(:answer) { create(:answer) }

    it 'renders show view' do
      get :show, params: { id: answer, question_id: question }
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to the database' do
        expect { post :create, params: { question_id: question, answer: { body: 'MyText' } }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create js view' do
        post :create, params: { question_id: question, answer: { body: 'MyText' } }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: { body: nil } }, format: :js }.to_not change(question.answers, :count)
      end

      it 'renders create js view' do
        post :create, params: { question_id: question, answer: { body: nil } }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'author of the answer' do
      before { login(user) }

      context 'with valid attributes' do
        let(:answer) { create(:answer, question: question, user: user) }

        before { patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js }

        it 'changes answer attributes' do
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:answer) { create(:answer, question: question, user: user) }

        it 'does not change the answer' do
          expect do
            patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            answer.reload
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'non-author of the answer' do
      let(:answer) { create(:answer, question: question, user: user) }

      before { login(user2) }

      it "doesn't change the answer" do
        expect do
          patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
        end.to_not change(answer, :body)
      end

      it 'returns a :forbidden status' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author of the answer' do
      let!(:answer) { create(:answer, user: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer} }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { question_id: question, id: answer}
        expect(response).to redirect_to question_answers_path(answer.question)
      end
    end

    context 'non-author of the answer' do
      let!(:answer) { create(:answer) }

      it "doesn't delete the answer" do
        expect { delete :destroy, params: { question_id: question, id: answer} }.to_not change(Answer, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { question_id: question, id: answer}
        expect(response).to redirect_to question_answers_path(answer.question)
      end
    end
  end
end
