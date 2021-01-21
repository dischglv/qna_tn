class AnswersController < ApplicationController
  def index
    @answers = Answer.all
  end

  def show; end

  def new; end

  def edit; end

  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      redirect_to question_answer_path(@answer.question, @answer)
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

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
