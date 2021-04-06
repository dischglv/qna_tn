class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_comments_#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
