class AnswersChannel < ApplicationCable::Channel
  def subscribed()
    stream_from "question_#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
