module Voted
  extend ActiveSupport::Concern

  def vote_for
    votable.add_positive_vote(current_user)

    if votable.save
      render_json
    else
      render_errors_json
    end
  end

  def vote_against
    votable.add_negative_vote(current_user)

    if votable.save
      render_json
    else
      render_errors_json
    end
  end

  def cancel_vote
    respond_to do |format|
      if votable.votes.where(user: current_user).present?
        format.json { render json: votable.votes.where(user: current_user).first.destroy }
      else
        format.json { render json: { error: "Vote doesn't exist" }, status: :forbidden }
      end
    end
  end

  private

  def render_errors_json
    respond_to do |format|
      format.json { render json: votable.errors.full_messages, status: :forbidden }
    end
  end

  def render_json
    respond_to do |format|
      format.json { render json: votable.votes }
    end
  end

  def votable
    @votable ||= model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end