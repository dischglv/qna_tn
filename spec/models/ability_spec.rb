require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:question_of_other) { create(:question, user: other) }
    before do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      question_of_other.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    end

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other) }

    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other) }

    it { should be_able_to :best, create(:answer, question: question) }
    it { should_not be_able_to :best, create(:answer, question: question_of_other) }

    it { should be_able_to :vote_for, create(:answer, user: other) }
    it { should_not be_able_to :vote_for, create(:answer, user: user) }

    it { should be_able_to :vote_against, create(:answer, user: other) }
    it { should_not be_able_to :vote_against, create(:answer, user: user) }

    it { should be_able_to :cancel_vote, create(:answer, user: other) }
    it { should_not be_able_to :cancel_vote, create(:answer, user: user) }

    it { should be_able_to :vote_for, create(:question, user: other) }
    it { should_not be_able_to :vote_for, create(:question, user: user) }

    it { should be_able_to :vote_against, create(:question, user: other) }
    it { should_not be_able_to :vote_against, create(:question, user: user) }

    it { should be_able_to :cancel_vote, create(:question, user: other) }
    it { should_not be_able_to :cancel_vote, create(:question, user: user) }

    it { should be_able_to :destroy, question.files.first }
    it { should_not be_able_to :destroy, question_of_other.files.first }

    it { should be_able_to :destroy, create(:question_link, linkable: question) }
    it { should_not be_able_to :destroy, create(:question_link, linkable: question_of_other) }
  end
end