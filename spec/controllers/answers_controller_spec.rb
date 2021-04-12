require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  it_behaves_like 'Votable' do
    let(:params) { { params: { question_id: question, id: answer }, format: :json } }
    let(:resource) { answer }
  end

  describe 'PATCH #best' do
    let!(:question) { create(:question, user: user) }
    let!(:answer_last_best) { create(:answer, question: question, best: true) }
    let!(:answer) { create(:answer, question: question) }

    context 'author of the question' do
      before { login user }

      context 'question exists with award' do
        let!(:award) { create(:award, question: question) }

        it 'changes the best answer' do
          expect { patch :best, params: { question_id: question, id: answer }, format: :js }.to change(question.answers, :best)
        end

        it 'assigns award to the user' do
          patch :best, params: { question_id: question, id: answer }, format: :js
          award.reload

          expect(award.user).to eq answer.user
        end

        it 'renders best view' do
          patch :best, params: { question_id: question, id: answer }, format: :js
          expect(response).to render_template :best
        end
      end

      context 'question exists without award' do
        it 'changes the best answer' do
          expect { patch :best, params: { question_id: question, id: answer }, format: :js }.to change(question.answers, :best)
        end

        it 'renders best view' do
          patch :best, params: { question_id: question, id: answer }, format: :js
          expect(response).to render_template :best
        end
      end
    end

    context 'non-author of the question' do
      before { login user2 }

      it 'does not change the best answer' do
        expect { patch :best, params: { question_id: question, id: answer }, format: :js }.to_not change(question.answers, :best)
      end

      it 'returns :forbidden status' do
        patch :best, params: { question_id: question, id: answer }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
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
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer}, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { question_id: question, id: answer}, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'non-author of the answer' do
      let!(:answer) { create(:answer, question: question) }

      it "doesn't delete the answer" do
        expect do
          delete :destroy, params: { question_id: question, id: answer}, format: :js
        end.to_not change(question.answers, :count)
      end

      it 'returns :forbidden status' do
        delete :destroy, params: { question_id: question, id: answer}, format: :js
        expect(response).to have_http_status :forbidden
      end
    end
  end
end
