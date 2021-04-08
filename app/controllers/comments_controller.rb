class CommentsController < ApplicationController

  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = commentable.comments.new(comment_params.merge(user: current_user))
    @comment.save
  end


  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def comment
    @comment ||= params[:id] ? Comment.find(params[:id]) : Comment.new
  end

  helper_method :comment

  def commentable
    if params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    elsif params[:question_id]
      @commentable = Question.find(params[:question_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?

    if commentable.is_a? Question
      ActionCable.server.broadcast(
        "question_comments_#{commentable.id}",
        comment: @comment
      )
    else
      ActionCable.server.broadcast(
        "question_comments_#{commentable.question.id}",
        comment: @comment
      )
    end
  end
end
