class AnswersSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :user_id, :links, :files

  has_many :comments

  def files
    object.files.map { |file| { file_url: rails_blob_path(file, only_path: true) } }
  end
end
