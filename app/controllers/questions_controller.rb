class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  after_action :publish_question, only: :create

  authorize_resource

  include Voted

  def index
    @questions = Question.all
  end

  def show
    answer.links.build
  end

  def new
    question.links.build
    question.build_award
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
    if current_user.author_of?(question)
      question.update(question_params)
    else
      render status: :forbidden
    end
  end

  def destroy
    question.destroy if current_user.author_of?(question)
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def answer
    @answer ||= question.answers.new
  end

  def comment
    @comment ||= question.comments.new
  end

  helper_method :question
  helper_method :comment
  helper_method :answer

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:name, :url], files: [], award_attributes: [:title, :image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      question: render_question
    )
  end

  def render_question
    QuestionsController.renderer.instance_variable_set(
      :@env, {
      "HTTP_HOST" => "localhost:3000",
      "HTTPS" => "off",
      "REQUEST_METHOD" => "GET",
      "SCRIPT_NAME" => '',
      "warden" => warden
      }
    )

    QuestionsController.render(
      partial: 'questions/question_preview',
      locals: { question: @question }
    )
  end
end
