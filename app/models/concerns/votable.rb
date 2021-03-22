module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def add_positive_vote(user)
    votes.create(user: user, value: 1)
  end

  def add_negative_vote(user)
    votes.create(user: user, value: -1)
  end

  def positive_votes
    votes.where(value: 1).count
  end

  def negative_votes
    votes.where(value: -1).count
  end

  def rating
    votes.sum(:value)
  end
end