class AnswerService
  def notify_subscribers(answer)
    answer.question.subscriptions.find_each do |subscription|
      AnswerMailer.notify(subscription.user, answer).deliver_later
    end
  end
end