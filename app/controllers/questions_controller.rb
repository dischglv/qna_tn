class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy if current_user.author_of?(question)
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def answer
    @answer = question.answers.new
  end

  helper_method :question

  helper_method :answer

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
