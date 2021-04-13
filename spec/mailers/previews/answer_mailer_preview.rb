# Preview all emails at http://localhost:3000/rails/mailers/answer_mailer
class AnswerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answer_mailer/notify
  def notify
    AnswerMailer.notify
  end

end
