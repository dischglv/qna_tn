class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validate :validate_user_votes_once
  validate :validate_vote_user
  validates :value, numericality: { only_integer: true, in: [-1, 1] }

  private

  def validate_user_votes_once
    if Vote.where(user: user, votable: votable).exists?
      errors.add(:vote, "Cancel before re-voting")
    end
  end

  def validate_vote_user
    errors.add(:vote, "Author can not vote") if votable && user.author_of?(votable)
  end
end
