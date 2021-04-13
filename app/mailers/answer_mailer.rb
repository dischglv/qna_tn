class AnswerMailer < ApplicationMailer

  def notify(user, answer)
    @user = user
    @answer = answer

    mail to: user.email
  end
end
