shared_examples_for 'Votable' do
  describe 'PATCH #vote_for' do

    context 'Authenticated user'do
      context 'non-author of the resource' do
        before { login user2 }

        context 'votes for the first time' do
          it 'changes number of question votes' do
            expect do
              patch :vote_for, params
              resource.reload
            end.to change(resource.votes.where("value = 1"), :count).by(1)
          end

          it 'renders votes in json' do
            patch :vote_for, params

            expect(response.body).to eq({ votes_for: resource.positive_votes, votes_against: resource.negative_votes, rating: resource.rating }.to_json)
          end

          it 'responds with success' do
            patch :vote_for, params

            expect(response).to have_http_status(:success)
          end
        end

        context 're-votes' do
          before { create(:vote, user: user2, votable: resource) }

          it 'does not change number of votes' do
            expect do
              patch :vote_for, params
              resource.reload
            end.to_not change(resource.votes.where("value = 1"), :count)
          end

          it 'renders error in json' do
            patch :vote_for, params

            expect(response.body).to eq(["Votes is invalid"].to_json)
          end

          it 'responds with forbidden status' do
            patch :vote_for, params

            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'author of the question' do
        before { login user }

        it 'does not change number of votes' do
          expect do
            patch :vote_for, params
            resource.reload
          end.to_not change(resource.votes.where("value = 1"), :count)
        end

        it 'renders error in json' do
          patch :vote_for, params

          expect(response.body).to eq(["Votes is invalid"].to_json)
        end

        it 'responds with forbidden status' do
          patch :vote_for, params

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not changes number of votes' do
        expect do
          patch :vote_for, params
          resource.reload
        end.to_not change(resource.votes.where("value = 1"), :count)
      end
    end
  end

  describe 'PATCH #vote_against' do

    context 'Authenticated user'do
      context 'non-author of the resource' do
        before { login user2 }

        context 'votes for the first time' do
          it 'changes number of resource votes' do
            expect do
              patch :vote_against, params
              resource.reload
            end.to change(resource.votes.where("value = -1"), :count).by(1)
          end

          it 'renders votes in json' do
            patch :vote_against, params

            expect(response.body).to eq({ votes_for: resource.positive_votes, votes_against: resource.negative_votes, rating: resource.rating }.to_json)
          end

          it 'responds with success' do
            patch :vote_against, params

            expect(response).to have_http_status(:success)
          end
        end

        context 're-votes' do
          before { create(:vote, user: user2, votable: resource) }

          it 'does not changes number of votes' do
            expect do
              patch :vote_against, params
              resource.reload
            end.to_not change(resource.votes.where("value = -1"), :count)
          end

          it 'renders error in json' do
            patch :vote_against, params

            expect(response.body).to eq(["Votes is invalid"].to_json)
          end

          it 'responds with forbidden status' do
            patch :vote_against, params

            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'author of the question' do
        before { login user }

        it 'does not changes number of votes' do
          expect do
            patch :vote_against, params
            resource.reload
          end.to_not change(resource.votes.where("value = -1"), :count)
        end

        it 'renders error in json' do
          patch :vote_against, params

          expect(response.body).to eq(["Votes is invalid"].to_json)
        end

        it 'responds with forbidden status' do
          patch :vote_against, params

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not changes number of votes' do
        expect do
          patch :vote_against, params
          resource.reload
        end.to_not change(resource.votes.where("value = -1"), :count)
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    before { login user2 }

    context 'User voted before' do
      let!(:vote) { create(:vote, votable: resource, user: user2, value: 1) }

      it "deletes user's vote" do
        expect do
          delete :cancel_vote, params
          resource.reload
        end.to change(resource.votes.where(user: user2), :count).by(-1)
      end

      it 'returns deleted vote in JSON' do
        delete :cancel_vote, params

        expect(response.body).to eq({ votes_for: resource.positive_votes, votes_against: resource.negative_votes, rating: resource.rating }.to_json)
      end
    end

    context 'User did not vote before' do
      it "does not delete any vote" do
        expect do
          delete :cancel_vote, params
          resource.reload
        end.to_not change(resource.votes, :count)
      end

      it 'renders error in json' do
        delete :cancel_vote, params

        expect(response.body).to eq({ error: "Vote doesn't exist" }.to_json)
      end

      it 'responds with forbidden status' do
        delete :cancel_vote, params

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end