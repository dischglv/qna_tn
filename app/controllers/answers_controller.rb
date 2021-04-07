class AnswersController < ApplicationController

  before_action :authenticate_user!
  after_action :publish_answer, only: :create

  load_and_authorize_resource

  include Voted

  def create
    @answer = question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy
  end

  def best
    authorize! :best, answer
    answer.make_best
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def comment
    @comment = answer.comments.new
  end

  helper_method :answer
  helper_method :question
  helper_method :comment

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@answer.question.id}",
      answer: render_answer
    )
  end

  def render_answer
    AnswersController.renderer.instance_variable_set(
      :@env, {
      "HTTP_HOST" => "localhost:3000",
      "HTTPS" => "off",
      "REQUEST_METHOD" => "GET",
      "SCRIPT_NAME" => '',
      "warden" => warden,
      "rack.input" => ''
    }
    )

    AnswersController.render(
      partial: 'answers/answer',
      locals: { answer: @answer, question: @answer.question }
    )
  end
end
