require 'rails_helper'

RSpec.describe AnswerService do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  before { users.each { |user| create(:subscription, user: user, question: question) } }

  it 'sends new answer notice to all users' do
    expect(AnswerMailer).to receive(:notify).with(question.user, answer).and_call_original
    users.each { |user| expect(AnswerMailer).to receive(:notify).with(user, answer).and_call_original }
    subject.notify_subscribers(answer)
  end
end