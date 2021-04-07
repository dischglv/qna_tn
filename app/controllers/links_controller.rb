class LinksController < ApplicationController

  def destroy
    authorize! :destroy, link
    link.destroy
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end

  helper_method :link

end
