require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  describe 'PATCH #vote_for' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user'do
      context 'non-author of the answer' do
        before { login user2 }

        context 'votes for the first time' do
          it 'changes number of answer votes' do
            expect do
              patch :vote_for, params: { question_id: question, id: answer }, format: :json
              answer.reload
            end.to change(answer.votes.where("value = 1"), :count).by(1)
          end

          it 'renders votes in json' do
            patch :vote_for, params: { question_id: question, id: answer }, format: :json

            expect(response.body).to eq({ votes_for: answer.positive_votes, votes_against: answer.negative_votes, rating: answer.rating }.to_json)
          end

          it 'responds with success' do
            patch :vote_for, params: { question_id: question, id: answer }, format: :json

            expect(response).to have_http_status(:success)
          end
        end

        context 're-votes' do
          before { create(:vote, user: user2, votable: answer) }

          it 'does not changes number of votes' do
            expect do
              patch :vote_for, params: { question_id: question, id: answer }, format: :json
              answer.reload
            end.to_not change(answer.votes.where("value = 1"), :count)
          end

          it 'renders error in json' do
            patch :vote_for, params: { question_id: question, id: answer }, format: :json

            expect(response.body).to eq(["Votes is invalid"].to_json)
          end

          it 'responds with forbidden status' do
            patch :vote_for, params: { question_id: question, id: answer }, format: :json

            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'author of the answer' do
        before { login user }

        it 'does not changes number of votes' do
          expect do
            patch :vote_for, params: { question_id: question, id: answer }, format: :json
            answer.reload
          end.to_not change(answer.votes.where("value = 1"), :count)
        end

        it 'renders error in json' do
          patch :vote_for, params: { question_id: question, id: answer }, format: :json

          expect(response.body).to eq(["Votes is invalid"].to_json)
        end

        it 'responds with forbidden status' do
          patch :vote_for, params: { question_id: question, id: answer }, format: :json

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not changes number of votes' do
        expect do
          patch :vote_for, params: { question_id: question, id: answer }, format: :json
          answer.reload
        end.to_not change(answer.votes.where("value = 1"), :count)
      end
    end
  end

  describe 'PATCH #vote_against' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user'do
      context 'non-author of the answer' do
        before { login user2 }

        context 'votes for the first time' do
          it 'changes number of answer votes' do
            expect do
              patch :vote_against, params: { question_id: question, id: answer }, format: :json
              answer.reload
            end.to change(answer.votes.where("value = -1"), :count).by(1)
          end

          it 'renders votes in json' do
            patch :vote_against, params: { question_id: question, id: answer }, format: :json

            expect(response.body).to eq({ votes_for: answer.positive_votes, votes_against: answer.negative_votes, rating: answer.rating }.to_json)
          end

          it 'responds with success' do
            patch :vote_against, params: { question_id: question, id: answer }, format: :json

            expect(response).to have_http_status(:success)
          end
        end

        context 're-votes' do
          before { create(:vote, user: user2, votable: answer) }

          it 'does not changes number of votes' do
            expect do
              patch :vote_against, params: { question_id: question, id: answer }, format: :json
              answer.reload
            end.to_not change(answer.votes.where("value = -1"), :count)
          end

          it 'renders error in json' do
            patch :vote_against, params: { question_id: question, id: answer }, format: :json

            expect(response.body).to eq(["Votes is invalid"].to_json)
          end

          it 'responds with forbidden status' do
            patch :vote_against, params: { question_id: question, id: answer }, format: :json

            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'author of the answer' do
        before { login user }

        it 'does not changes number of votes' do
          expect do
            patch :vote_against, params: { question_id: question, id: answer }, format: :json
            answer.reload
          end.to_not change(answer.votes.where("value = -1"), :count)
        end

        it 'renders error in json' do
          patch :vote_against, params: { question_id: question, id: answer }, format: :json

          expect(response.body).to eq(["Votes is invalid"].to_json)
        end

        it 'responds with forbidden status' do
          patch :vote_against, params: { question_id: question, id: answer }, format: :json

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not changes number of votes' do
        expect do
          patch :vote_against, params: { question_id: question, id: answer }, format: :json
          answer.reload
        end.to_not change(answer.votes.where("value = -1"), :count)
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    let!(:answer) { create(:answer, question: question, user: user) }
    before { login user2 }

    context 'User voted before' do
      let!(:vote) { create(:vote, votable: answer, user: user2, value: 1) }

      it "deletes user's vote" do
        expect do
          delete :cancel_vote, params: { question_id: question, id: answer }, format: :json
          answer.reload
        end.to change(answer.votes.where(user: user2), :count).by(-1)
      end

      it 'returns deleted vote in JSON' do
        delete :cancel_vote, params: { question_id: question, id: answer }, format: :json

        expect(response.body).to eq({ votes_for: answer.positive_votes, votes_against: answer.negative_votes, rating: answer.rating }.to_json)
      end
    end

    context 'User did not vote before' do
      it "does not delete any vote" do
        expect do
          delete :cancel_vote, params: { question_id: question, id: answer }, format: :json
          answer.reload
        end.to_not change(answer.votes, :count)
      end

      it 'renders error in json' do
        delete :cancel_vote, params: { question_id: question, id: answer }, format: :json

        expect(response.body).to eq({ error: "Vote doesn't exist" }.to_json)
      end

      it 'responds with forbidden status' do
        delete :cancel_vote, params: { question_id: question, id: answer }, format: :json

        expect(response).to have_http_status(:forbidden)
      end
    end
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
