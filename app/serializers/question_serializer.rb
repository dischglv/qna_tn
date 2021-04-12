class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :links, :files
  has_many :answers
  has_many :comments

  belongs_to :user

  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map { |file| { file_url: rails_blob_path(file, only_path: true) } }
  end
end
