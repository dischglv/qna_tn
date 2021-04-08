module Voted
  extend ActiveSupport::Concern

  def vote_for
    authorize! :vote_for, votable
    votable.add_positive_vote(current_user)

    if votable.save
      render_json
    else
      render_errors_json
    end
  end

  def vote_against
    authorize! :vote_against, votable
    votable.add_negative_vote(current_user)

    if votable.save
      render_json
    else
      render_errors_json
    end
  end

  def cancel_vote
    authorize! :cancel_vote, votable
    if votable.votes.where(user: current_user).present?
      votable.votes.where(user: current_user).first.destroy
      render_json
    else
      respond_to do |format|
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
      format.json { render json: { votes_for: votable.positive_votes, votes_against: votable.negative_votes, rating: votable.rating } }
    end
  end

  def votable
    @votable ||= model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end