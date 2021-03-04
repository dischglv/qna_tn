module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def add_positive_vote(user)
    votes.create(user: user, value: true)
  end

  def add_negative_vote(user)
    votes.create(user: user, value: false)
  end
end