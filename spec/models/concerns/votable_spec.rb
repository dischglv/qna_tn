require 'rails_helper'

shared_examples_for 'votable' do
  let(:user) { create(:user) }
  let(:model) { create(described_class.name.downcase.to_sym, user: user) }
  let(:user2) { create(:user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe 'method #add_positive_vote' do
    describe 'author of the model' do
      it 'does not change number of votes' do
        model.add_positive_vote(user)
        expect(model.votes.where("value = 1").count).to eq 0
      end
    end

    describe 'non-author of the model' do

      describe 'did vote for' do
        it 'does not change number of votes' do
          2.times { model.add_positive_vote(user2) }
          expect(model.votes.where("value = 1").count).to eq 1
        end
      end

      describe 'did vote against' do
        it 'does not change number of votes' do
          model.add_negative_vote(user2)
          model.add_positive_vote(user2)
          expect(model.votes.where("value = 1").count).to eq 0
        end
      end

      describe 'did not voted' do
        it 'does change number of votes' do
          model.add_positive_vote(user2)
          expect(model.votes.where("value = 1").count).to eq 1
        end
      end
    end
  end

  describe 'method #add_negative_vote' do
    describe 'author of the model' do
      it 'does not change number of votes' do
        model.add_negative_vote(user)
        expect(model.votes.where("value = -1").count).to eq 0
      end
    end

    describe 'non-author of the model' do
      describe 'did vote for' do
        it 'does not change number of votes' do
          model.add_positive_vote(user2)
          model.add_negative_vote(user2)
          expect(model.votes.where("value = -1").count).to eq 0
        end
      end

      describe 'did vote against' do
        it 'does not change number of votes' do
          2.times { model.add_negative_vote(user2) }
          expect(model.votes.where("value = -1").count).to eq 1
        end
      end

      describe 'did not voted' do
        it 'does change number of votes' do
          model.add_negative_vote(user2)
          expect(model.votes.where("value = -1").count).to eq 1
        end
      end
    end
  end


  describe 'method #positive_votes' do
    before { create_list(:vote, 3, votable: model, value: 1)}

    it 'returns number of positive votes' do
      expect(model.positive_votes).to eq 3
    end
  end

  describe 'method #negative_votes' do
    before { create_list(:vote, 3, votable: model, value: -1)}

    it 'returns number of positive votes' do
      expect(model.negative_votes).to eq 3
    end
  end

  describe 'method #rating' do
    before do
      create_list(:vote, 5, votable: model, value: 1)
      create_list(:vote, 3, votable: model, value: -1)
    end

    it 'return rating of votable' do
      expect(model.rating).to eq 2
    end
  end
end