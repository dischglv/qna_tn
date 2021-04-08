class AwardsController < ApplicationController
  def index
    @awards = current_user.awards
    authorize! :index, @award
  end
end
