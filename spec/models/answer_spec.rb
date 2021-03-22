require 'rails_helper'
require './spec/models/concerns/votable_spec.rb'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it 'validates that there exists only one best answer' do
    question = create(:question)
    answer1 = create(:answer, question: question, best: true)

    expect(build(:answer, question: question, best: true)).to_not be_valid
  end

  describe 'method .best' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    it 'returns best answer' do
      expect(question.answers.best).to eq best_answer
    end
  end

  describe 'method #make_best' do
    let(:question) { create(:question) }
    let!(:answer_new_best) { create(:answer, best: false, question: question) }

    context 'previous best exists' do
      context 'award for the question exists' do
        let!(:answer_previous_best) { create(:answer, best: true, question: question) }
        let!(:award) { create(:award, question: question) }

        before { answer_new_best.make_best }

        it 'sets attribute best to true for the answer' do
          answer_new_best.reload
          expect(answer_new_best.best).to be_truthy
        end

        it 'sets attribute best to false for the last best answer' do
          answer_previous_best.reload
          expect(answer_previous_best.best).to be_falsey
        end

        it 'rewards the best user' do
          award.reload

          expect(award.user).to eq answer_new_best.user
        end
      end

      context 'award for the question does not exists' do
        let!(:answer_previous_best) { create(:answer, best: true, question: question) }

        before { answer_new_best.make_best }

        it 'sets attribute best to true for the answer' do
          answer_new_best.reload
          expect(answer_new_best.best).to be_truthy
        end

        it 'sets attribute best to false for the last best answer' do
          answer_previous_best.reload
          expect(answer_previous_best.best).to be_falsey
        end
      end
    end

    context 'previous best does not exist' do
      context 'award for the question exists' do
        let!(:award) { create(:award, question: question) }

        before { answer_new_best.make_best }

        it 'sets attribute best to true for the answer' do
          answer_new_best.reload
          expect(answer_new_best.best).to be_truthy
        end

        it 'rewards the best user' do
          award.reload

          expect(award.user).to eq answer_new_best.user
        end
      end

      context 'award for the question does not exists' do
        before { answer_new_best.make_best }

        it 'sets attribute best to true for the answer' do
          answer_new_best.reload
          expect(answer_new_best.best).to be_truthy
        end
      end
    end
  end

  it_behaves_like 'votable'
end
