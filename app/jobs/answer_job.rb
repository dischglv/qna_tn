class AnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    AnswerService.new.notify_subscribers(answer)
  end
end
