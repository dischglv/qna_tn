require 'concerns/votable'

class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true
  validate :validates_only_best_answer

  def self.best
    where(best: true).first
  end

  def make_best
    previous_best_answer = question.answers.best

    Answer.transaction do
      if previous_best_answer.present?
        previous_best_answer.update!(best: false)
      end
      question.award&.reward_best(user)

      update!(best: true)
    end
  end

  private

  def validates_only_best_answer
    return unless best

    if question.answers.best.present?
      errors.add(:best, 'cannot have another best answer')
    end
  end
end
