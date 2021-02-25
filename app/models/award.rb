class Award < ApplicationRecord

  belongs_to :question

  validates :title, presence: true

  has_one_attached :image
end
