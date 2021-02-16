require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

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

    context 'previous best does not exist' do
      before { answer_new_best.make_best }

      it 'sets attribute best to true for the answer' do
        answer_new_best.reload
        expect(answer_new_best.best).to be_truthy
      end
    end
  end
end
