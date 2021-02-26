require 'uri'

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, optional: true

  validates :name, :url, presence: true
  validate :validates_url_format

  def validates_url_format
    uri = URI.parse(url)
    unless uri.is_a?(URI::HTTP) && !uri.host.nil?
      errors.add(:url, 'must be valid')
    end
  rescue URI::InvalidURIError
    errors.add(:url, 'must be valid')
  end
end
