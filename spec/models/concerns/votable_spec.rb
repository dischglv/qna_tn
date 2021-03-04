require 'rails_helper'

shared_examples_for 'votable' do
  let(:user) { create(:user) }
  let(:model) { create(described_class.name.downcase.to_sym, user: user) }
  let(:user2) { create(:user) }

  it { should have_many(:votes).dependent(:destroy) }

  # it '#add_positive_vote' do
  #   model.add_positive_vote(user2)
  #
  #   expect(model.votes.where(value: true).count).to eq 1
  # end

  describe 'method #add_positive_number' do
    describe 'author of the model' do
      it 'does not change number of votes' do
        model.add_positive_vote(user)
        expect(model.votes.where(value: true).count).to eq 0
      end
    end

    describe 'non-author of the model' do

      describe 'did vote for' do
        it 'does not change number of votes' do
          2.times { model.add_positive_vote(user2) }
          expect(model.votes.where(value: true).count).to eq 1
        end
      end

      describe 'did vote against' do
        it 'does not change number of votes' do
          model.add_negative_vote(user2)
          model.add_positive_vote(user2)
          expect(model.votes.where(value: true).count).to eq 0
        end
      end

      describe 'did not voted' do
        it 'does change number of votes' do
          model.add_positive_vote(user2)
          expect(model.votes.where(value: true).count).to eq 1
        end
      end
    end
  end

  describe 'method #add_negative_number' do
    describe 'author of the model' do
      it 'does not change number of votes' do
        model.add_negative_vote(user)
        expect(model.votes.where(value: false).count).to eq 0
      end
    end

    describe 'non-author of the model' do
      describe 'did vote for' do
        it 'does not change number of votes' do
          model.add_positive_vote(user2)
          model.add_negative_vote(user2)
          expect(model.votes.where(value: false).count).to eq 0
        end
      end

      describe 'did vote against' do
        it 'does not change number of votes' do
          2.times { model.add_negative_vote(user2) }
          expect(model.votes.where(value: false).count).to eq 1
        end
      end

      describe 'did not voted' do
        it 'does change number of votes' do
          model.add_negative_vote(user2)
          expect(model.votes.where(value: false).count).to eq 1
        end
      end
    end
  end



  # it '#add_negative_vote' do
  #   model.add_negative_vote(user2)
  #
  #   expect(model.votes.where(value: false).count).to eq 1
  # end
end