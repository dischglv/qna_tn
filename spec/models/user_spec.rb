require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:awards).dependent(:nullify) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'method #author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it "compares valid user with resource owner" do
      expect(user).to be_author_of(question)
    end

    it "compares invalid user with resource owner" do
      another_user = create(:user)
      question = create(:question, user: another_user)

      expect(user).to_not be_author_of(question)
    end
  end
end
