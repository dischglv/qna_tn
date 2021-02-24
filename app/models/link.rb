require 'uri'

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, optional: true

  validates :name, :url, presence: true
  validate :validates_url_format

  def validates_url_format
    URI.parse(url)
  rescue URI::InvalidURIError
    errors.add(:url, 'url must be valid')
  end
end
