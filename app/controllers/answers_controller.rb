class AnswersController < ApplicationController
  def index
    @answers = Answer.all
  end

  def show; end

  def new; end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer
end
