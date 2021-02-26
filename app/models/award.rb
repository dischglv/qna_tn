class Award < ApplicationRecord

  belongs_to :question
  belongs_to :user, optional: true

  validates :title, presence: true

  has_one_attached :image

  def reward_best(user)
    self.user = user
    self.save
  end
end
