require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe "notify" do
    let(:answer) { create(:answer) }
    let(:user) { create(:user) }
    let(:mail) { AnswerMailer.notify(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notify")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("There is new answer for the question #{answer.question.title}")
    end
  end

end
