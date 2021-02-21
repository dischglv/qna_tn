class FilesController < ApplicationController
  def destroy
    if current_user.author_of?(file.record)
      file.purge
    else
      head :forbidden
    end
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :file
end
