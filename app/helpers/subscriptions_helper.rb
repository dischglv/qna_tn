module SubscriptionsHelper
  def question_subscription(question)
    question.subscriptions.find_by(user_id: current_user)
  end
end
