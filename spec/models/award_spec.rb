require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional }

  it { should validate_presence_of :title }

  it 'has one attached image' do
    expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  describe 'method #reward_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:award) { create(:award, question: question) }

    it 'assigns user association to user' do
      award.reward_best(user)

      expect(award.user).to eq(user)
    end
  end
end
