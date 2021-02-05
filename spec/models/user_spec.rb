require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'method owes_resource' do
    let(:user) { create(:user) }

    it "compares valid user with resource owner" do
      question = create(:question, user: user)

      expect(user.owes_resource(question)).to be_truthy
    end

    it "compares invalid user with resource owner" do
      another_user = create(:user)
      question = create(:question, user: another_user)

      expect(user.owes_resource(question)).to be_falsey
    end
  end
end
