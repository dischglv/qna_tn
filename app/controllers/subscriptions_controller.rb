class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :destroy]

  authorize_resource

  def create
    unless current_user.subscriptions.find_by(question_id: @question)
      current_user.subscriptions.create(question: @question)
      flash[:notice] = 'You have been subscribed to the question!'
    end
  end

  def destroy
    if current_user.subscriptions.find_by(question_id: @question.id)
      current_user.subscriptions.find_by(question_id: @question.id).destroy
      flash[:notice] = 'You have been unsubscribed from the question!'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

end
