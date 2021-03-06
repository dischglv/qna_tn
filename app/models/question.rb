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

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true
end
