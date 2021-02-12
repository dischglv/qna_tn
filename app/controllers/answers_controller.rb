class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
    else
      render status: :forbidden
    end
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
    redirect_to question_answers_path(answer.question)
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question = Question.find(params[:question_id])
  end

  helper_method :answer

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
