class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validate :validates_only_best_answer

  def self.best
    where(best: true).first
  end

  def make_best
    previous_best_answer = question.answers.best
    if previous_best_answer.present?
      previous_best_answer.update(best: false)
    end

    update(best: true)
  end

  private

  def validates_only_best_answer
    return unless best

    if question.answers.best.present?
      errors.add(:best, 'cannot have another best answer')
    end
  end
end
