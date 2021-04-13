require 'concerns/votable'
require 'concerns/commentable'

class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_one :award, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :votable
  has_many :subscriptions, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true

  after_create :calculate_reputation
  after_create :subscribe_author

  scope :last_day, -> { where(created_at: 1.day.ago..Time.now) }

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_author
    user.subscriptions.create(question_id: id)
  end
end
