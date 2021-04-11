class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: :show

  authorize_resource

  def index
    @answers = Answer.all
    render json: @answers, serializer_each: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswersSerializer
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end
end