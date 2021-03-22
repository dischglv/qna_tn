require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'PATCH #vote_for' do

    context 'Authenticated user'do
      context 'non-author of the question' do
        before { login user2 }

        context 'votes for the first time' do
          it 'changes number of question votes' do
            expect do
              patch :vote_for, params: { id: question }, format: :json
              question.reload
            end.to change(question.votes.where("value = 1"), :count).by(1)
          end

          it 'renders votes in json' do
            patch :vote_for, params: { id: question }, format: :json

            expect(response.body).to eq({ votes_for: question.positive_votes, votes_against: question.negative_votes, rating: question.rating }.to_json)
          end

          it 'responds with success' do
            patch :vote_for, params: { id: question }, format: :json

            expect(response).to have_http_status(:success)
          end
        end

        context 're-votes' do
          before { create(:vote, user: user2, votable: question) }

          it 'does not changes number of votes' do
            expect do
              patch :vote_for, params: { id: question }, format: :json
              question.reload
            end.to_not change(question.votes.where("value = 1"), :count)
          end

          it 'renders error in json' do
            patch :vote_for, params: { id: question }, format: :json

            expect(response.body).to eq(["Votes is invalid"].to_json)
          end

          it 'responds with forbidden status' do
            patch :vote_for, params: { id: question }, format: :json

            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'author of the question' do
        before { login user }

        it 'does not change number of votes' do
          expect do
            patch :vote_for, params: { id: question }, format: :json
            question.reload
          end.to_not change(question.votes.where("value = 1"), :count)
        end

        it 'renders error in json' do
          patch :vote_for, params: { id: question }, format: :json

          expect(response.body).to eq(["Votes is invalid"].to_json)
        end

        it 'responds with forbidden status' do
          patch :vote_for, params: { id: question }, format: :json

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not changes number of votes' do
        expect do
          patch :vote_for, params: { id: question }, format: :json
          question.reload
        end.to_not change(question.votes.where("value = 1"), :count)
      end
    end
  end

  describe 'PATCH #vote_against' do

    context 'Authenticated user'do
      context 'non-author of the question' do
        before { login user2 }

        context 'votes for the first time' do
          it 'changes number of question votes' do
            expect do
              patch :vote_against, params: { id: question }, format: :json
              question.reload
            end.to change(question.votes.where("value = -1"), :count).by(1)
          end

          it 'renders votes in json' do
            patch :vote_against, params: { id: question }, format: :json

            expect(response.body).to eq({ votes_for: question.positive_votes, votes_against: question.negative_votes, rating: question.rating }.to_json)
          end

          it 'responds with success' do
            patch :vote_against, params: { id: question }, format: :json

            expect(response).to have_http_status(:success)
          end
        end

        context 're-votes' do
          before { create(:vote, user: user2, votable: question) }

          it 'does not changes number of votes' do
            expect do
              patch :vote_against, params: { id: question }, format: :json
              question.reload
            end.to_not change(question.votes.where("value = -1"), :count)
          end

          it 'renders error in json' do
            patch :vote_against, params: { id: question }, format: :json

            expect(response.body).to eq(["Votes is invalid"].to_json)
          end

          it 'responds with forbidden status' do
            patch :vote_against, params: { id: question }, format: :json

            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'author of the question' do
        before { login user }

        it 'does not changes number of votes' do
          expect do
            patch :vote_against, params: { id: question }, format: :json
            question.reload
          end.to_not change(question.votes.where("value = -1"), :count)
        end

        it 'renders error in json' do
          patch :vote_against, params: { id: question }, format: :json

          expect(response.body).to eq(["Votes is invalid"].to_json)
        end

        it 'responds with forbidden status' do
          patch :vote_against, params: { id: question }, format: :json

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not changes number of votes' do
        expect do
          patch :vote_against, params: { id: question }, format: :json
          question.reload
        end.to_not change(question.votes.where("value = -1"), :count)
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    before { login user2 }

    context 'User voted before' do
      let!(:vote) { create(:vote, votable: question, user: user2, value: 1) }

      it "deletes user's vote" do
        expect do
          delete :cancel_vote, params: { id: question }, format: :json
          question.reload
        end.to change(question.votes.where(user: user2), :count).by(-1)
      end

      it 'returns deleted vote in JSON' do
        delete :cancel_vote, params: { id: question }, format: :json

        expect(response.body).to eq({ votes_for: question.positive_votes, votes_against: question.negative_votes, rating: question.rating }.to_json)
      end
    end

    context 'User did not vote before' do
      it "does not delete any vote" do
        expect do
          delete :cancel_vote, params: { id: question }, format: :json
          question.reload
        end.to_not change(question.votes, :count)
      end

      it 'renders error in json' do
        delete :cancel_vote, params: { id: question }, format: :json

        expect(response.body).to eq({ error: "Vote doesn't exist" }.to_json)
      end

      it 'responds with forbidden status' do
        delete :cancel_vote, params: { id: question }, format: :json

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    before { login(user) }

    before { get :new }

    it 'assigns a new link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new award to @question' do
      expect(assigns(:question).build_award).to be_a_new(Award)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question to the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'author of the question' do
      before { login(user) }

      context 'with valid attributes' do

        it 'changes question attributes' do
          expect do
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
            question.reload
          end.to change(question, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end
      context 'with invalid attributes' do

        it 'does not change question' do
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          end.to_not change(question, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'non-author of the question' do
      before { sign_in user2 }

      it 'does not change question' do
        expect do
          patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
          question.reload
        end.to_not change(question, :body)
      end

      it 'returns :forbidden status' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author of the question' do
      let!(:question) { create(:question, user: user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'non-author of the question' do
      let!(:question) { create(:question) }

      it "doesn't delete the question" do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
