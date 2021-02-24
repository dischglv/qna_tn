class LinksController < ApplicationController

  def destroy
    if current_user.author_of?(link.linkable)
      link.destroy
    else
      head :forbidden
    end
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end

  helper_method :link

end
