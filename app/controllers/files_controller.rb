class FilesController < ApplicationController

  def destroy
    authorize! :destroy, file
    file.purge
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :file
end
