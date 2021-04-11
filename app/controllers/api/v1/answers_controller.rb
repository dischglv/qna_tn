class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: [:show, :update, :destroy]
  before_action :load_question, only: [:create]

  authorize_resource

  def index
    @answers = Answer.all
    render json: @answers, serializer_each: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswersSerializer
  end

  def create
    @answer = current_resource_owner.answers.new(answer_params.merge(question: @question))

    if @answer.save
      render json: @answer, serializer: AnswersSerializer
    else
      render json: { errors: @answer.errors.full_messages }
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, serializer: AnswersSerializer
    else
      render json: { errors: @answer.errors.full_messages }
    end
  end

  def destroy
    @answer.destroy!
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url])
  end
end