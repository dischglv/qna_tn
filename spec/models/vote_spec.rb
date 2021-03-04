require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it 'validates user can vote only once' do
    user = create(:user)
    answer = create(:answer)
    create(:vote, user: user, votable: answer, value: true)

    expect(Vote.create(user: user, votable: answer, value: false)).to_not be_valid
  end

  it 'validates user can not vote for his votables' do
    user = create(:user)
    answer = create(:answer, user: user)

    expect(Vote.create(user: user, votable: answer, value: false)).to_not be_valid
  end
end
