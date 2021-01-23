class AnswersController < ApplicationController
  def index
    @answers = Answer.all
  end

  def show; end

  def new; end

  def edit; end

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to question_answer_path(question, @answer)
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question_answer_path(answer.question, answer)
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
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
